import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Quickshell
import Quickshell.Widgets
import qs.widgets 
import qs.settings 
import qs.services

Item {
    anchors.fill: parent
    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.95

    Behavior on opacity {
        NumberAnimation { duration: Appearance.animation.medium; easing.type: Appearance.animation.easing }
    }
    Behavior on scale {
        NumberAnimation { duration: Appearance.animation.medium; easing.type: Appearance.animation.easing }
    }


    ColumnLayout {
        anchors.centerIn: parent

        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter


            ColumnLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                StyledText {
                    text: SystemDetails.osIcon
                    font.pixelSize: 280
                    horizontalAlignment: Text.AlignHCenter
                }

                StyledText {
                    text: "aelyx-shell"
                    font.pixelSize: 24
                    font.family: "Outfit ExtraBold"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: 400
                }

                StyledText {
                    text: "A Shell built to get things done."
                    font.pixelSize: 14
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: 400
                }
            }
            Item {}
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                StyledButton {
                    text: "View on GitHub"
                    icon: 'code'
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell")
                    topRightRadius: 5
                    bottomRightRadius: 5
                }
                StyledButton {
                    text: "Report Issue"
                    icon: "bug_report"
                    secondary: true
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell/issues")
                    topLeftRadius: 5
                    bottomLeftRadius: 5
                }

            }
        }
    }

    Rectangle {
        color: Appearance.m3colors.m3secondary
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        implicitHeight: updateText.height + 20
        implicitWidth: implicitHeight
        radius: 10
        StyledText {
            id: updateText
            text: "󰚰" // nerd fonts are somewhat good, but material symbols are way better :}
            font.pixelSize: 24
            color: Appearance.colors.m3onSecondary
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent 
            onClicked: {
                GlobalStates.visible_settingsMenu = false; 
                Quickshell.execDetached(["notify-send", "Updating aelyx-shell"])
                Quickshell.execDetached(["kitty", "--hold" ,"bash", "-c", "~/.local/share/aelyx/scripts/system/update.sh"])
            }
        }
    }

    StyledText {
        text: "ae-qs v" + Shell.flags.shellInfo.version
        font.pixelSize: 12
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        onLinkActivated: Qt.openUrlExternally(link)
    }

}