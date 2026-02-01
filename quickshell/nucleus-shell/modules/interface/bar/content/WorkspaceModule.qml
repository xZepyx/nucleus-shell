import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

Item {
    id: workspaceContainer

    property int numWorkspaces: Config.runtime.bar.modules.workspaces.workspaceIndicators
    property var workspaceOccupied: []
    property var occupiedRanges: []

    function japaneseNumber(num) {
        var kanjiMap = {
            "0": "零",
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "6": "六",
            "7": "七",
            "8": "八",
            "9": "九",
            "10": "十"
        };
        return kanjiMap[num] !== undefined ? kanjiMap[num] : "Number out of range";
    }

    function updateWorkspaceOccupied() {
        const offset = 1
        workspaceOccupied = Array.from({
            "length": numWorkspaces
        }, (_, i) => {
            return Compositor.isWorkspaceOccupied(Compositor.require("niri") ? (i + 1 + offset) : (i + 1));
        });
        const ranges = [];
        let start = -1;
        for (let i = 0; i < workspaceOccupied.length; i++) {
            if (workspaceOccupied[i]) {
                if (start === -1)
                    start = i;

            } else if (start !== -1) {
                ranges.push({
                    "start": start,
                    "end": i - 1
                });
                start = -1;
            }
        }
        if (start !== -1)
            ranges.push({
            "start": start,
            "end": workspaceOccupied.length - 1
        });

        occupiedRanges = ranges;
    }

    visible: Config.runtime.bar.modules.workspaces.enabled
    implicitWidth: bg.implicitWidth
    implicitHeight: Config.runtime.bar.modules.height
    Component.onCompleted: updateWorkspaceOccupied()

    Connections {
        function onStateChanged() {
            updateWorkspaceOccupied();
        }

        target: Compositor
    }

    Rectangle {
        id: bg

        color: Appearance.m3colors.m3paddingContainer
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large - 8
        implicitHeight: Config.runtime.bar.modules.height

        // occupied background highlight
        Item {
            id: occupiedStretchLayer

            anchors.centerIn: workspaceRow
            width: workspaceRow.width
            height: 26
            z: 0

            Repeater {
                model: occupiedRanges

                Rectangle {
                    height: 26
                    radius: Appearance.rounding.small
                    color: ColorUtils.mix(Appearance.m3colors.m3tertiary, Appearance.m3colors.m3surfaceContainerLowest)
                    opacity: 0.8
                    x: modelData.start * (26 + workspaceRow.spacing)
                    width: (modelData.end - modelData.start + 1) * 26 + (modelData.end - modelData.start) * workspaceRow.spacing
                }

            }

        }

        // workspace highlight
        Rectangle {
            id: highlight

            property int offset: Compositor.require("hyprland") ? 1 : 0
            property int index: Math.max(0, Compositor.focusedWorkspaceId - 1 - offset)
            property real itemWidth: 26
            property real spacing: workspaceRow.spacing
            property int highlightIndex: {
                if (!Compositor.focusedWorkspaceId) return 0
                if (Compositor.require("hyprland")) return Compositor.focusedWorkspaceId - 1 // Hyprland starts at 2 internally
                return Compositor.focusedWorkspaceId - 2 // Niri or default
            }
            property real targetX: Math.min(highlightIndex, numWorkspaces - 1) * (itemWidth + spacing) + 7.3            
            property real animatedX1: targetX
            property real animatedX2: targetX

            x: Math.min(animatedX1, animatedX2)
            anchors.verticalCenter: parent.verticalCenter
            width: Math.abs(animatedX2 - animatedX1) + itemWidth - 1
            height: 24
            radius: Appearance.rounding.small
            color: Appearance.m3colors.m3tertiary
            onTargetXChanged: {
                animatedX1 = targetX;
                animatedX2 = targetX;
            }

            Behavior on animatedX1 {
                enabled: Config.runtime.appearance.animations.enabled

                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutSine
                }

            }

            Behavior on animatedX2 {
                enabled: Config.runtime.appearance.animations.enabled

                NumberAnimation {
                    duration: 133
                    easing.type: Easing.OutSine
                }

            }

        }

        RowLayout {
            id: workspaceRow

            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: numWorkspaces

                Item {
                    property int wsIndex: index + 1
                    property bool focused: wsIndex === Compositor.focusedWorkspaceId
                    property bool occupied: Compositor.isWorkspaceOccupied(wsIndex)

                    width: 26
                    height: 26

                    ClippingRectangle {
                        id: iconContainer

                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        color: "transparent"
                        radius: Appearance.rounding.small
                        clip: true

                        IconImage {
                            id: appIcon

                            anchors.fill: parent
                            visible: Config.runtime.bar.modules.workspaces.showAppIcons && occupied
                            rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
                            source: {
                                const win = Compositor.focusedWindowForWorkspace(wsIndex);
                                return win ? Quickshell.iconPath(FileUtils.resolveIcon(win.class)) : "";
                            }
                        }

                    }

                    Tint {
                        rotation: iconContainer.rotation
                        sourceItem: appIcon
                    }

                    // Kanji mode: show Kanji everywhere
                    StyledText {
                        anchors.centerIn: parent
                        visible: Config.runtime.bar.modules.workspaces.showJapaneseNumbers
                        text: japaneseNumber(index + 1)
                    }

                    // Numbers mode: show numbers everywhere
                    StyledText {
                        anchors.centerIn: parent
                        visible: !Config.runtime.bar.modules.workspaces.showAppIcons && !Config.runtime.bar.modules.workspaces.showJapaneseNumbers
                        text: index + 1
                    }

                    // Note that if both kanji and icons are enabled both will be visible, in the settings app there is a enabled value so only one of them can be toggled

                    // Symbols for unoccupied workspaces when app icons enabled
                    MaterialSymbol {
                        property string displayText: {
                            const square = "crop_square";
                            const circle = "fiber_manual_record";
                            const useSquare = Config.runtime.appearance.rounding.factor === 0;
                            return useSquare ? square : circle;
                        }

                        anchors.centerIn: parent
                        visible: Config.runtime.bar.modules.workspaces.showAppIcons && !occupied
                        text: displayText
                        rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
                        font.pixelSize: 10
                        fill: 1
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Compositor.changeWorkspace(wsIndex)
                    }

                }

            }

        }

    }

}
