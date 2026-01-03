import qs.services
import qs.config
import qs.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            id: clock

            color: "transparent"
            visible: (Shell.flags.background.showClock && Shell.ready)
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData

            implicitWidth: 360
            implicitHeight: 160

            property int padding: 50

            anchors {
                top: Shell.flags.background.clockPosition.startsWith("top")
                bottom: Shell.flags.background.clockPosition.startsWith("bottom")
                left: Shell.flags.background.clockPosition.endsWith("left")
                right: Shell.flags.background.clockPosition.endsWith("right")
            }

            margins {
                top: padding
                bottom: padding
                left: padding
                right: padding
            }

            Column {
                anchors.fill: parent
                spacing: -40

                StyledText {
                    animate: false
                    text: Time.format(Shell.flags.background.clockTimeFormat)
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
    }
}
