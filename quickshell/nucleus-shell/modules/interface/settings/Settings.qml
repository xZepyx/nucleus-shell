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

    property Window settingsWindow: null

    IpcHandler {
        target: "settings"

        function open(menu: string) {
            Globals.states.settingsOpen = true

            if (!settingsWindow || menu === "")
                return

            const target = menu.toLowerCase()

            for (let i = 0; i < menuModel.count; i++) {
                const item = menuModel.get(i)

                if (!item.header && item.label.toLowerCase() === target) {
                    settingsWindow.selectedIndex = item.page
                    break
                }
            }
        }
    }

    LazyLoader {
        active: Globals.states.settingsOpen

        Window {
            id: root

            width: Screen.width * 0.7
            height: Screen.height * 0.75
            minimumWidth: 900
            minimumHeight: 600

            visible: true
            title: "Nucleus - Settings"

            color: Appearance.m3colors.m3background

            onClosing: Globals.states.settingsOpen = false
            Component.onCompleted: settingsWindow = root

            property int selectedIndex: 0
            property bool sidebarCollapsed: false

            ListModel {
                id: menuModel

                ListElement { header: true;  label: "System" }
                ListElement { icon: "bluetooth";     label: "Bluetooth";      page: 0 }
                ListElement { icon: "network_wifi";  label: "Network";        page: 1 }
                ListElement { icon: "volume_up";     label: "Audio";          page: 2 }
                ListElement { icon: "palette";       label: "Appearance";     page: 3 }

                ListElement { header: true; label: "Customization" }
                ListElement { icon: "toolbar";      label: "Bar";            page: 4 }
                ListElement { icon: "wallpaper";    label: "Wallpapers";     page: 5 }
                ListElement { icon: "apps";         label: "Launcher";       page: 6 }
                ListElement { icon: "notifications";label: "Notifications";  page: 7 }
                ListElement { icon: "extension";    label: "Plugins";        page: 8 }
                ListElement { icon: "store";        label: "Store";          page: 9 }
                ListElement { icon: "build";        label: "Miscellaneous";  page: 10 }

                ListElement { header: true; label: "About" }
                ListElement { icon: "info"; label: "About"; page: 11 }
            }

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

                                icon: root.sidebarCollapsed
                                      ? "left_panel_open"
                                      : "left_panel_close"

                                secondary: true

                                onClicked: root.sidebarCollapsed = !root.sidebarCollapsed
                            }
                        }

                        ListView {
                            id: sidebarList

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            model: menuModel
                            spacing: Metrics.spacing(5)
                            clip: true

                            delegate: Item {
                                width: sidebarList.width
                                height: model.header
                                        ? (root.sidebarCollapsed ? 0 : 30)
                                        : 42

                                visible: !model.header || !root.sidebarCollapsed

                                Item {
                                    width: parent.width
                                    height: parent.height

                                    StyledText {
                                        y: (parent.height - height) * 0.5
                                        x: 10
                                        text: model.label
                                        font.pixelSize: Metrics.fontSize(14)
                                        font.bold: true
                                        opacity: model.header ? 1 : 0
                                    }
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    visible: !model.header

                                    radius: Appearance.rounding.large

                                    color: root.selectedIndex === model.page
                                           ? Appearance.m3colors.m3primary
                                           : "transparent"

                                    RowLayout {
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10

                                        spacing: 10

                                        MaterialSymbol {
                                            visible: !model.header
                                            icon: model.icon ? model.icon : ""
                                            iconSize: Metrics.iconSize(24)
                                        }

                                        StyledText {
                                            text: model.label
                                            visible: !root.sidebarCollapsed
                                        }
                                    }
                                }

                                TapHandler {
                                    enabled: model.page !== undefined

                                    onTapped: {
                                        root.selectedIndex = model.page
                                    }
                                }
                            }
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.InOutCubic
                        }
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
