import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.components
import qs.config
import qs.services

Item {
    id: root

    anchors.fill: parent
    implicitWidth: 640
    implicitHeight: 520

    property int logoOffset: -30

    Column {
        anchors.centerIn: parent
        width: 460
        spacing: Metrics.spacing(12)

        Item {
            width: parent.width
            height: Metrics.fontSize(200)

            StyledText {
                text: SystemDetails.osIcon
                anchors.centerIn: parent
                x: root.logoOffset
                font.pixelSize: Metrics.fontSize(200)
            }
        }

        StyledText {
            text: "Nucleus Shell"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.family: "Outfit ExtraBold"
            font.pixelSize: Metrics.fontSize(26)
        }

        StyledText {
            text: "A shell built to get things done."
            width: parent.width
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Metrics.fontSize(14)
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Metrics.spacing(10)

            StyledButton {
                text: "View on GitHub"
                icon: "code"
                secondary: true
                onClicked: Qt.openUrlExternally("https://github.com/xZepyx/nucleus-shell")
            }

            StyledButton {
                text: "Report Issue"
                icon: "bug_report"
                secondary: true
                onClicked: Qt.openUrlExternally("https://github.com/xZepyx/nucleus-shell/issues")
            }
        }
    }

    StyledText {
        text: "Nucleus-Shell v" + Config.runtime.shell.version
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Metrics.margin(24)
        font.pixelSize: Metrics.fontSize(12)
    }

    StyledRect {
        id: updateBtn

        width: 52
        height: 52
        radius: Appearance.rounding.small

        color: updateMA.containsMouse
               ? Qt.lighter(Appearance.m3colors.m3secondaryContainer, 1.1)
               : Appearance.m3colors.m3secondaryContainer

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Metrics.margin(24)

        StyledText {
            text: "↻"
            anchors.centerIn: parent
            font.pixelSize: Metrics.fontSize(22)
        }

        MouseArea {
            id: updateMA
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                Globals.states.settingsOpen = false

                Quickshell.execDetached(["notify-send", "Updating Nucleus Shell"])

                Quickshell.execDetached([
                    "kitty",
                    "--hold",
                    "bash",
                    "-c",
                    Directories.scriptsPath + "/system/update.sh"
                ])
            }
        }
    }
}
