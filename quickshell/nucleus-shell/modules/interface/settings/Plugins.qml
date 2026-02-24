import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.components
import qs.plugins

ContentMenu {
    title: "Plugins"
    description: "Modify and Customize Installed Plugins."

    ContentCard {
        Layout.fillWidth: true
        Layout.preferredHeight: implicitHeight
        color: "transparent"

        GridLayout {
            id: grid
            columns: 1
            Layout.fillWidth: true
            columnSpacing: Metrics.spacing(16)
            rowSpacing: Metrics.spacing(16)

            StyledText {
                text: "Plugins not found!"
                font.pixelSize: Metrics.fontSize(20)
                font.bold: true
                visible: PluginLoader.plugins.length === 0
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                model: PluginLoader.plugins

                delegate: ContentCard {
                    Layout.fillWidth: true

                    Loader {
                        Layout.fillWidth: true
                        asynchronous: true
                        source: Qt.resolvedUrl(
                            Directories.shellConfig + "/plugins/" + modelData + "/Settings.qml"
                        )
                    }
                }
            }
        }
    }
}
