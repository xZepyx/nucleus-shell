import "../../widgets/morphedPolygons/geometry/offset.js" as Offset
import "../../widgets/morphedPolygons/material-shapes.js" as MaterialShapes // For polygons
import "../../widgets/morphedPolygons/shapes/corner-rounding.js" as CornerRounding
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.modules.widgets
import qs.modules.widgets.morphedPolygons
import qs.services

Scope {
    id: root

    property bool imageFailed: false

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clock

            required property var modelData
            property int padding: Config.runtime.appearance.background.clock.edgeSpacing
            property int clockHeight: Config.runtime.appearance.background.clock.isAnalog ? 250 : 160
            property int clockWidth: Config.runtime.appearance.background.clock.isAnalog ? 250 : 360

            function setRandomPosition() {
                const x = Math.floor(Math.random() * (width - clockWidth));
                const y = Math.floor(Math.random() * (height - clockHeight));
                animX.to = x;
                animY.to = y;
                moveAnim.start();
                Config.updateKey("appearance.background.clock.xPos", x);
                Config.updateKey("appearance.background.clock.yPos", y);
            }

            color: "transparent"
            visible: (Config.runtime.appearance.background.clock.enabled && Config.initialized && !imageFailed)
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData

            ParallelAnimation {
                id: moveAnim

                NumberAnimation {
                    id: animX

                    target: rootContentContainer
                    property: "x"
                    duration: 400
                    easing.type: Easing.InOutCubic
                }

                NumberAnimation {
                    id: animY

                    target: rootContentContainer
                    property: "y"
                    duration: 400
                    easing.type: Easing.InOutCubic
                }

            }

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                top: padding
                bottom: padding
                left: padding
                right: padding
            }

            Item {
                id: rootContentContainer

                property real releasedX: 0
                property real releasedY: 0

                height: clockHeight
                width: clockWidth
                Component.onCompleted: {
                    Qt.callLater(() => {
                        x = Config.runtime.appearance.background.clock.xPos;
                        y = Config.runtime.appearance.background.clock.yPos;
                    });
                }

                MouseArea {
                    id: ma

                    anchors.fill: parent
                    drag.target: rootContentContainer
                    drag.axis: Drag.XAndYAxis
                    onReleased: {
                        Config.updateKey("appearance.background.clock.xPos", rootContentContainer.x);
                        Config.updateKey("appearance.background.clock.yPos", rootContentContainer.y);
                    }
                }

                Item {
                    id: digitalClockContainer

                    visible: !Config.runtime.appearance.background.clock.isAnalog

                    Column {
                        spacing: -40

                        StyledText {
                            animate: false
                            text: Time.format("hh:mm")
                            font.pixelSize: Appearance.font.size.wildass * 3
                            font.family: Appearance.font.family.main
                            font.bold: true
                        }

                        StyledText {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            animate: false
                            text: Time.format("dddd, dd/MM")
                            font.pixelSize: 32
                            font.family: Appearance.font.family.main
                            font.bold: true
                        }

                    }

                }

                Item {
                    id: analogClockContainer

                    property int hours: parseInt(Time.format("hh"))
                    property int minutes: parseInt(Time.format("mm"))
                    property int seconds: parseInt(Time.format("ss"))
                    readonly property real cx: width / 2
                    readonly property real cy: height / 2
                    property var shapes: [MaterialShapes.getCookie7Sided, MaterialShapes.getCookie9Sided, MaterialShapes.getCookie12Sided, MaterialShapes.getPixelCircle, MaterialShapes.getCircle, MaterialShapes.getGhostish]

                    anchors.fill: parent
                    visible: Config.runtime.appearance.background.clock.isAnalog
                    width: clock.width / 1.1
                    height: clock.height / 1.1

                    // Polygon
                    MorphedPolygon {
                        id: shapeCanvas

                        anchors.fill: parent
                        color: Appearance.m3colors.m3surfaceContainerLow
                        roundedPolygon: analogClockContainer.shapes[Config.runtime.appearance.background.clock.shape]()
                    }

                    // Hour hand
                    Rectangle {
                        z: 1
                        width: 12
                        height: parent.height * 0.38
                        radius: Appearance.rounding.full
                        color: Qt.darker(Appearance.m3colors.m3secondary, 0.8)
                        x: analogClockContainer.cx - width / 2
                        y: analogClockContainer.cy - height
                        transformOrigin: Item.Bottom
                        rotation: (analogClockContainer.hours % 12 + analogClockContainer.minutes / 60) * 30
                    }

                    // Minute hand
                    Rectangle {
                        width: 12
                        height: parent.height * 0.3
                        radius: Appearance.rounding.full
                        color: Appearance.m3colors.m3secondary
                        x: analogClockContainer.cx - width / 2
                        y: analogClockContainer.cy - height
                        transformOrigin: Item.Bottom
                        rotation: analogClockContainer.minutes * 6
                    }

                    // Second hand
                    Rectangle {
                        visible: false
                        width: 4
                        height: parent.height * 0.22
                        radius: Appearance.rounding.full
                        color: Appearance.m3colors.m3error
                        x: analogClockContainer.cx - width / 2
                        y: analogClockContainer.cy - height
                        transformOrigin: Item.Bottom
                        rotation: analogClockContainer.seconds * 6
                    }

                    StyledText {
                        text: Time.format("ddd MMM d")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height / 4 - 30
                        font.bold: true
                    }

                    IpcHandler {
                        function changePosition() {
                            clock.setRandomPosition();
                        }

                        target: "clock"
                    }

                }

            }

        }

    }

}
