import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.functions
import qs.modules.components
import qs.services

Scope {
    property var settingsWindow: null

    IpcHandler {
        function open(menu: string) {
            Globals.states.settingsOpen = true;

            if (menu !== "" && settingsWindow !== null) {
                for (var i = 0; i < settingsWindow.menuModel.length; i++) {
                    var item = settingsWindow.menuModel[i];
                    if (!item.header && item.label.toLowerCase() === menu.toLowerCase()) {
                        settingsWindow.selectedIndex = item.page;
                        break;
                    }
                }
            }
        }
        target: "settings"
    }

    LazyLoader {
        active: Globals.states.settingsOpen

        Window {
            id: root
            width: 1280
            height: 720
            visible: true
            title: "Nucleus - Settings"
            color: Appearance.m3colors.m3background
            onClosing: Globals.states.settingsOpen = false
            Component.onCompleted: settingsWindow = root

            property int selectedIndex: 0
            property bool sidebarCollapsed: false

            property var menuModel: [
                { "header": true, "label": "System" },
                { "icon": "bluetooth", "label": "Bluetooth", "page": 0 },
                { "icon": "network_wifi", "label": "Network", "page": 1 },
                { "icon": "volume_up", "label": "Audio", "page": 2 },
                { "icon": "instant_mix", "label": "Appearance", "page": 3 },

                { "header": true, "label": "Customization" },
                { "icon": "toolbar", "label": "Bar", "page": 4 },
                { "icon": "wallpaper", "label": "Wallpapers", "page": 5 },
                { "icon": "apps", "label": "Launcher", "page": 6 },
                { "icon": "chat", "label": "Notifications", "page": 7 },
                { "icon": "extension", "label": "Plugins", "page": 8 },
                { "icon": "apps", "label": "Store", "page": 9 },
                { "icon": "build", "label": "Miscellaneous", "page": 10 },

                { "header": true, "label": "About" },
                { "icon": "info", "label": "About", "page": 11 }
            ]

            Item {
                anchors.fill: parent
                Rectangle {
                    id: sidebarBG
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: root.sidebarCollapsed ? 80 : 350
                    color: Appearance.m3colors.m3surfaceContainerLow

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Metrics.margin(40)
                        spacing: Metrics.spacing(5)

                        RowLayout {
                            Layout.fillWidth: true

                            StyledText {
                                Layout.fillWidth: true
                                text: "Settings"
                                font.family: "Outfit ExtraBold"
                                font.pixelSize: Metrics.fontSize(28)
                                visible: !root.sidebarCollapsed
                            }

                            StyledButton {
                                Layout.preferredHeight: 40
                                icon: root.sidebarCollapsed ? "chevron_right" : "chevron_left"
                                secondary: true
                                onClicked: root.sidebarCollapsed = !root.sidebarCollapsed
                            }
                        }

                        ListView {
                            id: sidebarList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: root.menuModel
                            spacing: Metrics.spacing(5)
                            clip: true

                            delegate: Item {
                                width: sidebarList.width
                                height: modelData.header ? (root.sidebarCollapsed ? 0 : 30) : 42
                                visible: !modelData.header || !root.sidebarCollapsed

                                // header
                                Item {
                                    width: parent.width
                                    height: parent.height

                                    StyledText {
                                        y: (parent.height - height) * 0.5
                                        x: 10
                                        text: modelData.label
                                        font.pixelSize: Metrics.fontSize(14)
                                        font.bold: true
                                        opacity: modelData.header ? 1 : 0
                                    }

                                }

                                Rectangle {
                                    anchors.fill: parent
                                    visible: !modelData.header
                                    radius: Appearance.rounding.large
                                    color: root.selectedIndex === modelData.page
                                           ? Appearance.m3colors.m3primary
                                           : "transparent"

                                    RowLayout {
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        spacing: 10

                                        MaterialSymbol {
                                            visible: !modelData.header
                                            icon: modelData.icon ? modelData.icon : ""
                                            iconSize: Metrics.iconSize(24)
                                        }

                                        StyledText {
                                            text: modelData.label
                                            visible: !root.sidebarCollapsed
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: modelData.page !== undefined
                                    onClicked: {
                                        root.selectedIndex = modelData.page
                                        settingsStack.currentIndex = modelData.page
                                    }
                                }
                            }
                        }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 180; easing.type: Easing.InOutCubic }
                    }
                }


                StackLayout {
                    id: settingsStack
                    anchors.left: sidebarBG.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    currentIndex: root.selectedIndex

                    BluetoothConfig    { Layout.fillWidth: true; Layout.fillHeight: true }
                    NetworkConfig      { Layout.fillWidth: true; Layout.fillHeight: true }
                    AudioConfig        { Layout.fillWidth: true; Layout.fillHeight: true }
                    AppearanceConfig   { Layout.fillWidth: true; Layout.fillHeight: true }
                    BarConfig          { Layout.fillWidth: true; Layout.fillHeight: true }
                    WallpaperConfig    { Layout.fillWidth: true; Layout.fillHeight: true }
                    LauncherConfig     { Layout.fillWidth: true; Layout.fillHeight: true }
                    NotificationConfig { Layout.fillWidth: true; Layout.fillHeight: true }
                    Plugins            { Layout.fillWidth: true; Layout.fillHeight: true }
                    Store              { Layout.fillWidth: true; Layout.fillHeight: true }
                    MiscConfig         { Layout.fillWidth: true; Layout.fillHeight: true }
                    About              { Layout.fillWidth: true; Layout.fillHeight: true }
                }
            }
        }
    }
}
