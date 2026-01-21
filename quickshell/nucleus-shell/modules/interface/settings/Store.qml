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
            columns: 2
            columnSpacing: 16
            rowSpacing: 16
            anchors.fill: parent

            Repeater {
                model: PluginParser.model

                delegate: StyledRect {
                    Layout.preferredWidth: parent.width / 2.08
                    Layout.preferredHeight: 590
                    radius: 10
                    color: Appearance.m3colors.m3surfaceContainer

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 6

                        ClippingRectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 400
                            radius: Appearance.rounding.small

                            Image {
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectCrop
                                source: img !== "none" ? img : "image://icon/plugin"
                            }

                        }

                        StyledText {
                            text: name
                            font.pixelSize: 20
                            elide: Text.ElideRight
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.topMargin: 12
                            Layout.rightMargin: 8
                        }

                        StyledText {
                            text: description
                            font.pixelSize: 16
                            color: Appearance.colors.colSubtext
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Layout.rightMargin: 8
                        }

                        StyledText {
                            text: "v" + version + " • " + author
                            font.pixelSize: 12
                            color: Appearance.colors.colSubtext
                            Layout.rightMargin: 8
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        RowLayout {
                            spacing: 8
                            Layout.topMargin: 12
                            Layout.bottomMargin: 12
                            Layout.alignment: Qt.AlignBottom

                            StyledButton {
                                icon: "download"
                                text: "Install"
                                visible: !installed
                                secondary: true
                                onClicked: PluginParser.install(id)
                                Layout.preferredWidth: 160
                            }

                            StyledButton {
                                icon: "update"
                                text: "Update"
                                visible: installed
                                secondary: true
                                onClicked: PluginParser.update(id)
                                Layout.preferredWidth: 160
                            }

                            StyledButton {
                                icon: "delete"
                                text: "Remove"
                                visible: installed
                                secondary: true
                                onClicked: PluginParser.uninstall(id)
                                Layout.preferredWidth: 160
                            }

                        }

                    }

                }

            }

        }

    }

}
