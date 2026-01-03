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

    // Main card
    Rectangle {
        width: 420
        height: 260
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

            // Icon at top
            MaterialSymbol {
                text: "waving_hand"
                font.pixelSize: Appearance.font.size.wildass
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // Main heading
            StyledText {
                text: "Hey There!"
                font.pixelSize: Appearance.font.size.hugeass
                font.bold: true
                color: Appearance.colors.colOnLayer2
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // Subtext
            StyledText {
                text: "Let's configure your system!"
                font.pixelSize: Appearance.font.size.small
                color: Appearance.colors.colSubtext
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
