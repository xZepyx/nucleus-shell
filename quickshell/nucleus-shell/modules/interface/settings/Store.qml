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
        Layout.fillWidth: true

        GridLayout {
            columns: 1
            Layout.fillWidth: true
            columnSpacing: Metrics.spacing(16)
            rowSpacing: Metrics.spacing(16)

            Repeater {
                model: PluginParser.model

                delegate: StyledRect {
                    Layout.preferredHeight: 90
                    Layout.fillWidth: true
                    radius: Metrics.radius("small")
                    color: Appearance.m3colors.m3surfaceContainer

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Metrics.margin("normal")
                        spacing: Metrics.spacing(12)

                        Column {
                            Layout.fillWidth: true
                            spacing: Metrics.spacing(2)

                            StyledText {
                                font.pixelSize: Metrics.fontSize("large")
                                text: name
                            }

                            RowLayout {
                                spacing: Metrics.spacing(6)

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

                        RowLayout {
                            spacing: Metrics.spacing(8)

                            StyledButton {
                                icon: "download"
                                text: "Install"
                                visible: !installed
                                secondary: true
                                Layout.preferredWidth: 140
                                onClicked: PluginParser.install(id)
                            }

                            StyledButton {
                                icon: "update"
                                text: "Update"
                                visible: installed
                                secondary: true
                                Layout.preferredWidth: 140
                                onClicked: PluginParser.update(id)
                            }

                            StyledButton {
                                icon: "delete"
                                text: "Remove"
                                visible: installed
                                secondary: true
                                Layout.preferredWidth: 140
                                onClicked: PluginParser.uninstall(id)
                            }
                        }
                    }
                }
            }
        }
    }
}
