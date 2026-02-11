import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.components
import qs.plugins

ContentMenu {
    title: "Store"
    description: "Manage plugins and other stuff for the shell."

    ContentCard {
        GridLayout {
            columns: 1
            columnSpacing: Metrics.spacing(16)
            rowSpacing: Metrics.spacing(16)
            anchors.fill: parent

            Repeater {
                model: PluginParser.model

                delegate: StyledRect {
                    Layout.preferredHeight: 90
                    Layout.fillWidth: true
                    radius: Metrics.radius("small")
                    color: Appearance.m3colors.m3surfaceContainer

                    RowLayout {
                        spacing: Metrics.spacing(8)
                        anchors.margins: Metrics.margin("normal")
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        StyledButton {
                            icon: "download"
                            text: "Install"
                            visible: !installed
                            secondary: true
                            onClicked: PluginParser.install(id)
                            Layout.preferredWidth: 140
                        }

                        StyledButton {
                            icon: "update"
                            text: "Update"
                            visible: installed
                            secondary: true
                            onClicked: PluginParser.update(id)
                            Layout.preferredWidth: 140
                        }

                        StyledButton {
                            icon: "delete"
                            text: "Remove"
                            visible: installed
                            secondary: true
                            onClicked: PluginParser.uninstall(id)
                            Layout.preferredWidth: 140
                        }

                    }

                    Column {
                        anchors.top: parent.top
                        spacing: Metrics.spacing(2)
                        anchors.left: parent.left
                        anchors.margins: Metrics.margin("normal")

                        StyledText {
                            font.pixelSize: Metrics.fontSize("large")
                            text: name
                        }

                        RowLayout {
                            StyledText {
                                font.pixelSize: Metrics.fontSize("small")
                                text: author
                                color: Appearance.colors.colSubtext
                            }
                            StyledText {
                                font.pixelSize: Metrics.fontSize("small")
                                text: "| Requires Nucleus " + requires_nucleus
                                color: Appearance.colors.colSubtext
                            }
                        }

                        StyledText {
                            font.pixelSize: Metrics.fontSize("normal")
                            text: description
                            color: Appearance.colors.colSubtext
                        }

                    }

                }

            }

        }

    }

}
