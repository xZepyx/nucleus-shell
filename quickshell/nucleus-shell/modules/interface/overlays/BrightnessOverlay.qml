import qs.config
import qs.modules.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell
import Quickshell.Widgets

Scope {
    id: root

    Connections {
        target: Brightness

        function onBrightnessChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            visible: Config.runtime.overlays.brightnessOverlayEnabled && Config.runtime.overlays.enabled
            WlrLayershell.namespace: "nucleus:brightnessOsd"
            exclusiveZone: 0
			anchors.top: Config.runtime.overlays.brightnessOverlayPosition.startsWith("top")
            anchors.bottom: Config.runtime.overlays.brightnessOverlayPosition.startsWith("bottom")
            anchors.right: Config.runtime.overlays.brightnessOverlayPosition.endsWith("right")
            anchors.left: Config.runtime.overlays.brightnessOverlayPosition.endsWith("left")
			margins {
                top: Metrics.margin(10)
                bottom: Metrics.margin(10)
                left: Metrics.margin(10)
                right: Metrics.margin(10)
            }

			implicitWidth: 460
			implicitHeight: 105
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: Appearance.rounding.childish
                color: Appearance.m3colors.m3background

                RowLayout {
                    spacing: Metrics.spacing(10)
					anchors {
						fill: parent
						leftMargin: Metrics.margin(15)
						rightMargin: Metrics.margin(25)
					}

                    MaterialSymbol {
                        property real brightnessLevel: Math.floor(Brightness.getMonitorForScreen(Hyprland.focusedMonitor)?.multipliedBrightness*100)
                        icon: {
                            if (brightnessLevel > 66) return "brightness_high"
                            else if (brightnessLevel > 33) return "brightness_medium"
                            else return "brightness_low"
                        }
                        iconSize: Metrics.iconSize(30)
                    }

                    ColumnLayout {
                        implicitHeight: 40
                        spacing: Metrics.spacing(5)

                        StyledText {            
                            animate: false
                            text: "Brightness - " + Math.round(monitor.brightness * 100) + '%'
                            font.pixelSize: Metrics.fontSize(18)
                        }

                        StyledSlider {
                            implicitHeight: 35
                            from: 0
                            to: 100
                            value: Math.round(monitor.brightness * 100)
                        }
                    }
                }
            }
        }
    }
}
