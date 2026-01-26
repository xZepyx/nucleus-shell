import QtQuick
import QtQuick.Layouts
import Quickshell
import "content/"
import qs.config

Item {
    property bool isHorizontal: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom")

    Row {
        id: hCenterRow

        visible: isHorizontal
        anchors.centerIn: parent
        spacing: 4

        MediaPlayerModule {
        }

        ActiveWindowModule {
        }

        SystemUsageModule {
        }

        ClockModule {
        }

        BatteryIndicatorModule {
        }

    }

    RowLayout {
        id: hLeftRow

        visible: isHorizontal
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        anchors.leftMargin: Config.runtime.bar.density * 0.3 // Dynamic Margins

        ToggleModule {
            icon: "menu"
            iconSize: 23
            iconColor: Appearance.m3colors.m3error
            toggle: Globals.visiblility.sidebarLeft
            onToggled: {
                if (Globals.visiblility.sidebarRight)
                    return
                Globals.visiblility.sidebarLeft = value
            }
        }

        WorkspaceModule {
        }

    }

    RowLayout {
        id: hRightRow

        visible: isHorizontal
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        anchors.rightMargin: Config.runtime.bar.density * 0.3

        BongoCat {
            Layout.rightMargin: 20
        }

        StatusIconsModule {
        }

        ToggleModule {
            icon: "power_settings_new"
            iconSize: 22
            iconColor: Appearance.m3colors.m3error
            toggle: Globals.visiblility.powermenu
            onToggled: Globals.visiblility.powermenu = value
        }

    }

    // Vertical Layout
    Item {
        visible: !isHorizontal
        anchors.top: parent.top
        anchors.topMargin: Config.runtime.bar.density * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        // Contain rotated bounds
        implicitWidth: vRow.implicitHeight
        implicitHeight: vRow.implicitWidth

        Row {
            id: vRow

            anchors.centerIn: parent
            spacing: 8
            rotation: 90

            ToggleModule {
                icon: "menu" // Better on vertical Bar
                iconSize: 22
                iconColor: Appearance.m3colors.m3error
                rotation: 270
                toggle: Globals.visiblility.sidebarLeft
                onToggled: {
                    if (Globals.visiblility.sidebarRight)
                        return
                    Globals.visiblility.sidebarLeft = value
                }
            }

            SystemUsageModule {
            }

            MediaPlayerModule {
            }

            BongoCat {
            }

        }

    }

    Item {
        visible: !isHorizontal
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 35
        implicitWidth: centerRow.implicitHeight
        implicitHeight: centerRow.implicitWidth

        Row {
            id: centerRow

            anchors.centerIn: parent

            WorkspaceModule {
                rotation: 90
            }

        }

    }

    Item {
        visible: !isHorizontal
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Config.runtime.bar.density * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: row.implicitHeight
        implicitHeight: row.implicitWidth

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 6
            rotation: 90

            ClockModule {
                rotation: 270
            }

            StatusIconsModule {
            }

            BatteryIndicatorModule {
            }

            ToggleModule {
                icon: "power_settings_new"
                iconSize: 22
                iconColor: Appearance.m3colors.m3error
                toggle: Globals.visiblility.powermenu
                rotation: 270
                onToggled: Globals.visiblility.powermenu = value
            }

        }

    }

}
