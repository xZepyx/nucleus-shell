import qs.config
import qs.modules.components
import qs.services
import qs.modules.functions
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects
import "content/"

Item {
    anchors.fill: parent
    anchors.leftMargin: Appearance.margin.normal
    anchors.rightMargin: Appearance.margin.normal
    anchors.topMargin: Appearance.margin.large
    anchors.bottomMargin: Appearance.margin.large

    ColumnLayout {
        id: mainLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Appearance.margin.tiny
        anchors.rightMargin: Appearance.margin.tiny
        anchors.margins: Appearance.margin.large
        spacing: Appearance.margin.large

        // --- Top Section ---
        RowLayout {
            id: topSection
            Layout.fillWidth: true

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                RowLayout {
                    spacing: 8

                    StyledText {
                        text: SystemDetails.osIcon
                        font.pixelSize: Appearance.font.size.hugeass + 6
                    }

                    StyledText {
                        text: SystemDetails.uptime
                        font.pixelSize: Appearance.font.size.large
                        Layout.alignment: Qt.AlignBottom
                        Layout.bottomMargin: 5
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Row {
                spacing: 6
                Layout.leftMargin: 25
                Layout.alignment: Qt.AlignVCenter

                StyledRect {
                    id: editbtncontainer
                    color: "transparent"
                    radius: Appearance.rounding.large
                    implicitHeight: editButton.height + Appearance.margin.tiny
                    implicitWidth: editButton.width + Appearance.margin.small
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.topMargin: 10
                    Layout.leftMargin: 15

                    MaterialSymbolButton {
                        id: editButton
                        icon: "edit"
                        anchors.centerIn: parent
                        iconSize: Appearance.font.size.hugeass + 2

                        onButtonClicked: {
                            Quickshell.execDetached(["wl-color-picker"])
                            Globals.visiblility.sidebarRight = false;
                        }
                    }
                }

                StyledRect {
                    id: reloadbtncontainer
                    color: "transparent"
                    radius: Appearance.rounding.large
                    implicitHeight: reloadButton.height + Appearance.margin.tiny
                    implicitWidth: reloadButton.width + Appearance.margin.small
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.topMargin: 10
                    Layout.leftMargin: 15

                    MaterialSymbolButton {
                        id: reloadButton
                        icon: "refresh"
                        anchors.centerIn: parent
                        iconSize: Appearance.font.size.hugeass + 4

                        onButtonClicked: {
                            Quickshell.execDetached(["bash", "-c", Directories.scriptsPath + "/system/reload.sh"])
                        }
                    }
                }

                StyledRect {
                    id: settingsbtncontainer
                    color: "transparent"
                    radius: Appearance.rounding.large
                    implicitHeight: settingsButton.height + Appearance.margin.tiny
                    implicitWidth: settingsButton.width + Appearance.margin.small
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.topMargin: 10
                    Layout.leftMargin: 15

                    MaterialSymbolButton {
                        id: settingsButton
                        icon: "settings"
                        anchors.centerIn: parent
                        iconSize: Appearance.font.size.hugeass + 2

                        onButtonClicked: {
                            Globals.visiblility.sidebarRight = false
                            Globals.states.settingsOpen = true
                        }
                    }
                }

                StyledRect {
                    id: powerbtncontainer
                    color: "transparent"
                    radius: Appearance.rounding.large
                    implicitHeight: settingsButton.height + Appearance.margin.tiny
                    implicitWidth: settingsButton.width + Appearance.margin.small
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.topMargin: 10
                    Layout.leftMargin: 15

                    MaterialSymbolButton {
                        id: powerButton
                        icon: "power_settings_new"
                        anchors.centerIn: parent
                        iconSize: Appearance.font.size.hugeass + 2

                        onButtonClicked: {
                            Globals.visiblility.sidebarRight = false
                            Globals.visiblility.powermenu = true
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Appearance.m3colors.m3outlineVariant
            radius: 1
        }

        ColumnLayout {
            id: sliderColumn
            Layout.fillWidth: true

            VolumeSlider {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                icon: "volume_up"
                iconSize: Appearance.font.size.large + 3
            }

            BrightnessSlider {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                icon: "brightness_high"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Appearance.m3colors.m3outlineVariant
            radius: 1
        }

        GridLayout {
            id: middleGrid
            Layout.fillWidth: true
            columns: 1
            columnSpacing: 8
            rowSpacing: 8
            Layout.preferredWidth: parent.width

            RowLayout {
                Network {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                }
                FlightModeToggle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                }
            }

            RowLayout {
                Bluetooth {
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 80
                }
                ThemeToggle {
                    Layout.preferredHeight: 80
                    Layout.fillWidth: true
                }
                NightModeToggle {
                    Layout.preferredHeight: 80
                    Layout.fillWidth: true
                }
            }
        }

        ColumnLayout {
            spacing: Appearance.margin.small
            Layout.fillWidth: true

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Appearance.m3colors.m3outlineVariant
                radius: 1
                Layout.topMargin: 5
                Layout.bottomMargin: 5
            }
            
            NotifModal {
                Layout.preferredHeight: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 480 : 470
            }
        }
    }
}
