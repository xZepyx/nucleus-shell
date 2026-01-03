import QtQuick
import QtQuick.Layouts
import qs.functions
import qs.config
import qs.widgets
import qs.services

ContentMenu {
    title: "Network"
    description: "Manage network connections."

    ContentCard {
        ContentRowCard {
            cardSpacing: 0
            verticalPadding: Network.wifiEnabled ? 10 : 0
            cardMargin: 0

            StyledText {
                text: powerSwitch.checked ? "Wi-Fi: On" : "Wi-Fi: Off"
                font.pixelSize: 16
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                id: powerSwitch
                checked: Network.wifiEnabled
                onToggled: Network.enableWifi(checked)
            }
        }

        ContentRowCard {
            visible: Network.wifiEnabled
            cardSpacing: 0
            verticalPadding: 10
            cardMargin: 0

            ColumnLayout {
                spacing: 2

                StyledText {
                    text: "Scanning"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "Search for nearby Wi-Fi networks."
                    font.pixelSize: 12
                    color: ColorModifier.transparentize(
                        Appearance.m3colors.m3onSurface, 0.4
                    )
                }
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                checked: Network.scanning
                onToggled: {
                    if (checked)
                        Network.rescan()
                }
            }
        }
    }

    InfoCard {
        visible: Network.message !== "" && Network.message !== "ok"
        icon: "error"
        backgroundColor: Appearance.m3colors.m3error
        contentColor: Appearance.m3colors.m3onError
        title: "Failed to connect to " + Network.lastNetworkAttempt
        description: Network.message
    }

    ContentCard {
        visible: Network.active !== null

        StyledText {
            text: "Active Connection"
            font.pixelSize: 18
            font.bold: true
        }

        NetworkCard {
            connection: Network.active
            isActive: true
            showDisconnect: Network.active?.type === "wifi"
        }
    }

    ContentCard {
        visible: Network.connections.filter(c => c.type === "ethernet").length > 0

        StyledText {
            text: "Ethernet"
            font.pixelSize: 18
            font.bold: true
        }

        Repeater {
            model: Network.connections.filter(c => c.type === "ethernet" && !c.active)
            delegate: NetworkCard {
                connection: modelData
                showConnect: true
            }
        }
    }

    ContentCard {
        visible: Network.wifiEnabled

        StyledText {
            text: "Available Wi-Fi Networks"
            font.pixelSize: 18
            font.bold: true
        }

        Item {
            visible: Network.connections.filter(c => c.type === "wifi").length === 0 && !Network.scanning
            width: parent.width
            height: 40

            StyledText {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: "No networks found"
                font.pixelSize: 14
                color: ColorModifier.transparentize(Appearance.m3colors.m3onSurface, 0.4)
            }

        }

        Repeater {
            model: Network.connections.filter(c => c.type === "wifi" && !c.active)
            delegate: NetworkCard {
                connection: modelData
                showConnect: true
            }
        }
    }

    ContentCard {
        visible: Network.savedNetworks.length > 0
        StyledText {
            text: "Remembered Networks"
            font.pixelSize: 18
            font.bold: true
        }

        Item {
            visible: Network.savedNetworks.length === 0
            width: parent.width
            height: 40
            StyledText {
                anchors.left: parent.left
                text: "No remembered networks"
                font.pixelSize: 14
                color: Appearance.colors.colSubtext
            }
        }

        Repeater {
            model: Network.connections.filter(c => c.type === "wifi" && c.saved && !c.active)
            delegate: NetworkCard {
                connection: modelData
                showConnect: false
                showDisconnect: false
            }
        }
    }
}
