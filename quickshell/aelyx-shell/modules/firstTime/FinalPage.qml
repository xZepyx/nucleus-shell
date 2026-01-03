import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.widgets
import qs.config
import Quickshell.Io

Item {

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Appearance.colors.colLayer0 }
            GradientStop { position: 1.0; color: Appearance.colors.colLayer1 }
        }
    }

    Rectangle {
        width: 420
        height: 280
        radius: Appearance.rounding.windowRounding
        color: Appearance.colors.colLayer2
        anchors.centerIn: parent
        border.color: Appearance.colors.colLayer0Border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Appearance.margin.normal
            spacing: Appearance.margin.small
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            // Check icon
            MaterialSymbol {
                text: "check_circle"
                font.pixelSize: Appearance.font.size.wildass
                color: Appearance.colors.colPrimary
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // Main heading
            StyledText {
                text: "All Set!"
                font.pixelSize: Appearance.font.size.hugeass
                font.bold: true
                color: Appearance.colors.colOnLayer2
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // Subtext
            StyledText {
                text: "Your system is ready to go."
                font.pixelSize: Appearance.font.size.small
                color: Appearance.colors.colSubtext
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
