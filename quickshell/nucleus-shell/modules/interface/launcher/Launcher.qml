import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.config
import qs.modules.functions
import qs.modules.components
import qs.services

PanelWindow {
    id: launcher

    function togglelauncher() {
        Globals.visiblility.launcher = !Globals.visiblility.launcher;
        if (!Globals.visiblility.launcher) {
            searchField.text = "";
            launcherContent.resetSearch();
        }
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.launcher
    WlrLayershell.keyboardFocus: Globals.visiblility.launcher
    WlrLayershell.namespace: "nucleus:launcher"
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: DisplayMetrics.scaledWidth(0.28)
    implicitHeight: DisplayMetrics.scaledHeight(0.7)
    onVisibleChanged: {
        if (!Globals.visiblility.launcher) {
            searchField.text = "";
            launcherContent.resetSearch();
        } else {
            Qt.callLater(() => {
                return searchField.forceActiveFocus();
            });
        }
    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    margins {
        top: Metrics.margin(10)
        bottom: Metrics.margin(10)
        left: Metrics.margin(10)
        right: Metrics.margin(10)
    }

    Rectangle {
        id: overlay
        anchors.fill: parent 
        color: "transparent"
        MouseArea {
            id: ma 
            anchors.fill: parent
            onClicked: {
                Globals.visiblility.launcher = false;
            }
        }
    }

    mask: Region {
        item: overlay
        intersection: Intersection.Xor
    }

    FocusScope {
        id: launcherFocus

        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Qt.Key_Down:
                launcherContent.moveSelection(+1);
                event.accepted = true;
                break;
            case Qt.Key_Up:
                launcherContent.moveSelection(-1);
                event.accepted = true;
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
                launcherContent.launchCurrent();
                event.accepted = true;
                break;
            case Qt.Key_Escape:
                launcherContent.closeLauncher();
                event.accepted = true;
                break;
            }
        }

        StyledRect {
            color: Appearance.m3colors.m3background
            topLeftRadius: Metrics.radius("verylarge")
            topRightRadius: Metrics.radius("verylarge")
            bottomLeftRadius: searchField.text !== "" ? 0 : Metrics.radius("verylarge")
            bottomRightRadius: searchField.text !== "" ? 0 : Metrics.radius("verylarge")
            implicitWidth: launcher.implicitWidth
            implicitHeight: 65
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            StyledTextField {
                id: searchField

                height: 50
                filled: false
                radius: Metrics.radius("verylarge")
                anchors.fill: parent
                icon: ""
                highlight: false
                placeholder: "Search applications..."
                font.pixelSize: Metrics.fontSize(15)
                outline: false
                onTextChanged: {
                    if (launcherContent.searchQuery === text)
                        return;

                    launcherContent.searchQuery = text;
                    launcherContent.updateFilter();
                }

            }

            Behavior on bottomLeftRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Metrics.chronoDuration(100)
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on bottomRightRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Metrics.chronoDuration(100)
                    easing.type: Easing.BezierSpline
                }

            }

        }

        StyledRect {
            // padding compensation

            id: container

            readonly property real maxResultsHeight: launcher.implicitHeight - 130
            readonly property real contentHeightClamped: Math.min(launcherContent.listView.contentHeight + 50, maxResultsHeight)

            color: Appearance.m3colors.m3background
            topLeftRadius: searchField.text !== "" ? 0 : Metrics.radius("verylarge")
            topRightRadius: searchField.text !== "" ? 0 : Metrics.radius("verylarge")
            bottomLeftRadius: Metrics.radius("verylarge") 
            bottomRightRadius: Metrics.radius("verylarge")
            opacity: searchField.text !== "" ? 1 : 0
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Metrics.margin(65)
            implicitWidth: launcher.implicitWidth
            implicitHeight: searchField.text !== "" ? contentHeightClamped : 0

            Rectangle {
                anchors.top: parent.top
                height: 1
                width: parent.width
                color: Appearance.colors.colOutline
            }

            LauncherContent {
                id: launcherContent

                searchQuery: searchField.text
                anchors.fill: parent
            }

            Behavior on topLeftRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Metrics.chronoDuration(100)
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on topRightRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Metrics.chronoDuration(100)
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on implicitHeight {
                enabled: Config.runtime.appearance.animations.enabled
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }

        }

    }

    IpcHandler {
        function toggle() {
            togglelauncher();
        }

        target: "launcher"
    }

}
