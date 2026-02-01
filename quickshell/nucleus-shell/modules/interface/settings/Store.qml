import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.widgets
import qs.plugins

ContentMenu {
    title: "Store"
    description: "Manage plugins and other stuff for the shell."

    ContentCard {
        GridLayout {
            columns: 1
            columnSpacing: 16
            rowSpacing: 16
            anchors.fill: parent

            Repeater {
                model: PluginParser.model

                delegate: StyledRect {
                    Layout.preferredHeight: 90
                    Layout.fillWidth: true
                    radius: Appearance.rounding.small
                    color: Appearance.m3colors.m3surfaceContainer

                    RowLayout {
                        spacing: 8
                        anchors.margins: 12
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
                        spacing: 2
                        anchors.left: parent.left
                        anchors.margins: 12

                        StyledText {
                            font.pixelSize: 19 // Some Good Ass Perfection
                            text: name
                        }

                        RowLayout {
                            StyledText {
                                font.pixelSize: 12
                                text: author
                                color: Appearance.colors.colSubtext
                            }
                            StyledText {
                                font.pixelSize: 12
                                text: "| Requires Nucleus " + requires_nucleus
                                color: Appearance.colors.colSubtext
                            }
                        }

                        StyledText {
                            font.pixelSize: 16
                            text: description
                            color: Appearance.colors.colSubtext
                        }

                    }

                }

            }

        }

    }

}
