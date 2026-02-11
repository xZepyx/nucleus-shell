pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Wayland
import qs.config
import qs.modules.components

Scope {
    id: root
    property bool active: false
    property rect selectedRegion: Qt.rect(0, 0, 0, 0)
    property string tempScreenshot: ""

    IpcHandler {
        target: "screen"
        function capture() {
            if (root.active) {
                console.info("screencap", "already active");
                return;
            }
            console.info("screencap", "starting capture");
            root.active = true;
        }
    }

    LazyLoader {
        active: root.active
        component: PanelWindow {
            id: win
            property bool closing: false
            property bool ready: false
            property bool processing: false
            property bool windowMode: false
            property string savedPath: ""
            property bool savedSuccess: false

            color: Appearance.m3colors.m3surface
            anchors { top: true; left: true; right: true; bottom: true }
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "nucleus:screencapture"

            Component.onCompleted: {
                var ts = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss");
                root.tempScreenshot = "/tmp/screenshot_" + ts + ".png";
            }

            function close() {
                if (closing) return;
                closing = true;
                closeAnim.start();
            }

            function saveFullscreen() {
                console.info("screencap", "saveFullscreen started");
                win.processing = true;
                screencopy.grabToImage(function(result) {
                    console.info("screencap", "fullscreen grabbed");
                    var ts = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss");
                    win.savedPath = Quickshell.env("HOME") + "/Pictures/Screenshots/screenshot_" + ts + ".png";

                    console.info("screencap", "saving to: " + win.savedPath);
                    if (result.saveToFile(win.savedPath)) {
                        console.info("screencap", "saved, copying");
                        Quickshell.execDetached({
                            command: ["sh", "-c", "cat '" + win.savedPath + "' | wl-copy --type image/png"]
                        });
                        win.savedSuccess = true;
                    } else {
                        console.info("screencap", "save failed");
                        win.savedSuccess = false;
                    }
                    win.processing = false;
                    console.info("screencap", "closing window");
                    win.close();
                });
            }

            Component {
                id: ffmpegProc
                Process {
                    property string outputPath
                    property bool success: false

                    onExited: (code) => {
                        console.info("screencap", "ffmpeg exited: " + code);
                        success = code === 0;

                        if (success) {
                            console.info("screencap", "copying to clipboard");
                            Quickshell.execDetached({
                                command: ["sh", "-c", "cat '" + outputPath + "' | wl-copy --type image/png"]
                            });
                        }

                        Quickshell.execDetached({ command: ["rm", root.tempScreenshot] });

                        win.savedSuccess = success;
                        win.processing = false;
                        console.info("screencap", "done, closing");
                        win.close();
                        destroy();
                    }
                }
            }

            function saveRegion(rect, suffix) {
                console.info("screencap", "saveRegion started: " + rect.x + "," + rect.y + " " + rect.width + "x" + rect.height);
                screencopy.grabToImage(function(result) {
                    console.info("screencap", "full screenshot grabbed for cropping");
                    if (!result.saveToFile(root.tempScreenshot)) {
                        console.info("screencap", "ERROR: failed to save temp screenshot");
                        win.savedSuccess = false;
                        win.processing = false;
                        win.close();
                        return;
                    }

                    console.info("screencap", "temp saved, cropping with ffmpeg");
                    var ts = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss");
                    win.savedPath = Quickshell.env("HOME") + "/Pictures/Screenshots/screenshot_" + ts + suffix + ".png";

                    ffmpegProc.createObject(win, {
                        command: ["ffmpeg", "-i", root.tempScreenshot, "-vf", "crop=" + Math.floor(rect.width) + ":" + Math.floor(rect.height) + ":" + Math.floor(rect.x) + ":" + Math.floor(rect.y), "-y", win.savedPath],
                        outputPath: win.savedPath,
                        running: true
                    });
                });
            }

            function captureFullscreen() {
                win.processing = true;
                saveFullscreen();
            }

            function captureWindow(rect) {
                win.processing = true;
                saveRegion(rect, "_window");
            }

            function captureRegion() {
                if (!ready || !selection.hasSelection) return;
                win.processing = true;
                saveRegion(root.selectedRegion, "_region");
            }

            ScreencopyView {
                id: screencopy
                anchors.fill: parent
                captureSource: win.screen
                z: -999
                live: false

                onHasContentChanged: {
                    console.info("screencap", "hasContent: " + hasContent);
                    if (hasContent) {
                        console.info("screencap", "grabbing for preview");
                        grabToImage(function(result) {
                            console.info("screencap", "preview grabbed: " + result.url);
                            frozen.source = result.url;
                            readyTimer.start();
                        });
                    }
                }
            }

            Timer {
                id: readyTimer
                interval: Metrics.chronoDuration("normal") + 50
                onTriggered: {
                    console.info("screencap", "UI ready");
                    win.ready = true;
                }
            }

            Item {
                anchors.fill: parent
                focus: true

                Keys.onEscapePressed: win.close()
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_F) {
                        win.captureFullscreen();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_W) {
                        win.windowMode = !win.windowMode;
                        event.accepted = true;
                    }
                }

                Image {
                    id: bg
                    anchors.fill: parent
                    source: Config.runtime.appearance.background.path
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0
                    scale: 1

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 1.0
                        blurMax: 64
                        brightness: -0.1
                    }

                    onStatusChanged: {
                        if (status === Image.Ready) fadeIn.start();
                    }

                    NumberAnimation on opacity {
                        id: fadeIn
                        to: 1
                        duration: Metrics.chronoDuration("normal")
                        easing.type: Appearance.animation.easing
                    }
                }

                Item {
                    id: container
                    anchors.centerIn: parent
                    width: win.width
                    height: win.height

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowOpacity: 1
                        shadowColor: Appearance.m3colors.m3shadow
                    }

                    Image {
                        id: frozen
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        cache: false
                    }

                    Item {
                        id: darkOverlay
                        anchors.fill: parent
                        visible: (selection.hasSelection || selection.selecting) && !win.windowMode

                        Rectangle {
                            y: 0
                            width: parent.width
                            height: selection.sy
                            color: "black"
                            opacity: 0.5
                        }
                        Rectangle {
                            y: selection.sy + selection.h
                            width: parent.width
                            height: parent.height - (selection.sy + selection.h)
                            color: "black"
                            opacity: 0.5
                        }
                        Rectangle {
                            x: 0
                            y: selection.sy
                            width: selection.sx
                            height: selection.h
                            color: "black"
                            opacity: 0.5
                        }
                        Rectangle {
                            x: selection.sx + selection.w
                            y: selection.sy
                            width: parent.width - (selection.sx + selection.w)
                            height: selection.h
                            color: "black"
                            opacity: 0.5
                        }

                        Rectangle {
                            x: selection.sx
                            y: selection.sy
                            width: selection.w
                            height: selection.h
                            color: "black"
                            opacity: win.processing ? 0.6 : 0

                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }

                            LoadingIcon {
                                anchors.centerIn: parent
                                visible: win.processing
                            }
                        }
                    }

                    Rectangle {
                        id: outline
                        x: selection.sx
                        y: selection.sy
                        width: selection.w
                        height: selection.h
                        color: "transparent"
                        border.color: Appearance.m3colors.m3primary
                        border.width: 2
                        visible: (selection.selecting || selection.hasSelection) && !win.windowMode
                    }

                    Rectangle {
                        visible: selection.selecting
                        anchors.top: outline.bottom
                        anchors.topMargin: Metrics.margin(10)
                        anchors.horizontalCenter: outline.horizontalCenter
                        width: coords.width + 10
                        height: coords.height + 10
                        color: Appearance.m3colors.m3surface
                        radius: Metrics.radius(20)

                        StyledText {
                            id: coords
                            anchors.centerIn: parent
                            font.pixelSize: Metrics.fontSize(14)
                            animate: false
                            color: Appearance.m3colors.m3onSurface
                            property real scaleX: container.width / win.width
                            property real scaleY: container.height / win.height
                            text: Math.floor(selection.sx/scaleX) + "," + Math.floor(selection.sy/scaleY) + " " + Math.floor(selection.w/scaleX) + "x" + Math.floor(selection.h/scaleY)
                        }
                    }

                    MouseArea {
                        id: selection
                        anchors.fill: parent
                        enabled: win.ready && !win.windowMode

                        property real x1: 0
                        property real y1: 0
                        property real x2: 0
                        property real y2: 0
                        property bool selecting: false
                        property bool hasSelection: false

                        property real xp: 0
                        property real yp: 0
                        property real wp: 0
                        property real hp: 0

                        property real sx: xp * parent.width
                        property real sy: yp * parent.height
                        property real w: wp * parent.width
                        property real h: hp * parent.height

                        onPressed: mouse => {
                            if (!win.ready) return;
                            x1 = Math.max(0, Math.min(mouse.x, width));
                            y1 = Math.max(0, Math.min(mouse.y, height));
                            x2 = x1;
                            y2 = y1;
                            selecting = true;
                            hasSelection = false;
                        }

                        onPositionChanged: mouse => {
                            if (selecting) {
                                x2 = Math.max(0, Math.min(mouse.x, width));
                                y2 = Math.max(0, Math.min(mouse.y, height));
                                xp = Math.min(x1, x2) / width;
                                yp = Math.min(y1, y2) / height;
                                wp = Math.abs(x2 - x1) / width;
                                hp = Math.abs(y2 - y1) / height;
                            }
                        }

                        onReleased: mouse => {
                            if (!selecting) return;

                            x2 = Math.max(0, Math.min(mouse.x, width));
                            y2 = Math.max(0, Math.min(mouse.y, height));
                            selecting = false;

                            hasSelection = Math.abs(x2 - x1) > 5 && Math.abs(y2 - y1) > 5;

                            if (hasSelection) {
                                xp = Math.min(x1, x2) / width;
                                yp = Math.min(y1, y2) / height;
                                wp = Math.abs(x2 - x1) / width;
                                hp = Math.abs(y2 - y1) / height;

                                root.selectedRegion = Qt.rect(
                                    Math.min(x1, x2) * win.screen.width / width,
                                    Math.min(y1, y2) * win.screen.height / height,
                                    Math.abs(x2 - x1) * win.screen.width / width,
                                    Math.abs(y2 - y1) * win.screen.height / height
                                );

                                win.captureRegion();
                            } else {
                                win.close();
                            }
                        }
                    }

                    Repeater {
                        model: {
                            if (!win.windowMode || !win.ready) return [];
                            var ws = Hyprland.focusedMonitor?.activeWorkspace;
                            return ws?.toplevels ? ws.toplevels.values : [];
                        }

                        delegate: Item {
                            required property var modelData
                            property var w: modelData?.lastIpcObject
                            visible: w?.at && w?.size

                            property real barX: 0
                            property real barY: 0
                            property real sx: container.width / (win.screen.width - barX)
                            property real sy: container.height / (win.screen.height - barY)

                            x: visible ? (w.at[0] - barX) * sx : 0
                            y: visible ? (w.at[1] - barY) * sy : 0
                            width: visible ? w.size[0] * sx : 0
                            height: visible ? w.size[1] * sy : 0
                            z: w?.floating ? (hover.containsMouse ? 1000 : 100) : (hover.containsMouse ? 50 : 0)

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: Appearance.m3colors.m3primary
                                border.width: hover.containsMouse ? 3 : 0
                                radius: Metrics.radius(8)
                                Behavior on border.width {
                                    NumberAnimation { duration: Metrics.chronoDuration(150) }
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: Appearance.m3colors.m3primary
                                opacity: hover.containsMouse ? 0.15 : 0
                                radius: Metrics.radius(8)
                                Behavior on opacity {
                                    NumberAnimation { duration: Metrics.chronoDuration(150) }
                                }
                            }

                            MouseArea {
                                id: hover
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    win.captureWindow(Qt.rect(w.at[0], w.at[1], w.size[0], w.size[1]));
                                }
                            }
                        }
                    }

                    ParallelAnimation {
                        running: win.visible && !win.closing && frozen.source != ""

                        NumberAnimation {
                            target: bg
                            property: "scale"
                            to: bg.scale + 0.05
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: container
                            property: "width"
                            to: win.width * 0.8
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: container
                            property: "height"
                            to: win.height * 0.8
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                    }

                    ParallelAnimation {
                        id: closeAnim

                        NumberAnimation {
                            target: bg
                            property: "scale"
                            to: bg.scale - 0.05
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: container
                            property: "width"
                            to: win.width
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: container
                            property: "height"
                            to: win.height
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: darkOverlay
                            property: "opacity"
                            to: 0
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }
                        NumberAnimation {
                            target: outline
                            property: "opacity"
                            to: 0
                            duration: Metrics.chronoDuration("normal")
                            easing.type: Appearance.animation.easing
                        }

                        onFinished: {
                            root.active = false;
                            if (win.savedSuccess) {
                                Quickshell.execDetached({
                                    command: ["notify-send", "Screenshot saved", win.savedPath.split("/").pop() + " (copied)"]
                                });
                            } else if (win.savedPath !== "") {
                                Quickshell.execDetached({
                                    command: ["notify-send", "Screenshot failed", "Could not save"]
                                });
                            }
                        }
                    }
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Metrics.margin(30)
                    width: row.width + 20
                    height: row.height + 20
		            visible: false

                    Rectangle {
                        anchors.fill: parent
                        color: Appearance.m3colors.m3surface
                        radius: Metrics.radius("large")
                    }

                    RowLayout {
                        id: row
                        anchors.centerIn: parent

                        StyledButton {
                            icon: "fullscreen"
                            text: "Full screen"
                            tooltipText: "Capture the whole screen [F]"
                            onClicked: win.captureFullscreen()
                        }
                        Rectangle {
                            Layout.fillHeight: true
                            width: 2
                            color: Appearance.m3colors.m3onSurfaceVariant
                            opacity: 0.2
                        }
                        StyledButton {
                            icon: "window"
                            checkable: true
                            checked: win.windowMode
                            text: "Window"
                            tooltipText: "Hover and click a window [W]"
                            onClicked: win.windowMode = !win.windowMode
                        }
                        StyledButton {
                            secondary: true
                            icon: "close"
                            tooltipText: "Exit [Escape]"
                            onClicked: win.close()
                        }
                    }
                }
            }

            HyprlandFocusGrab {
                id: grab
                windows: [win]
            }

            onVisibleChanged: {
                if (visible) grab.active = true
            }

            Connections {
                target: grab
                function onActiveChanged() {
                    if (!grab.active && !win.closing) win.close();
                }
            }
        }
    }
}
