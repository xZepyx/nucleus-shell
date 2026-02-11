import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.services
import qs.modules.functions

Item {
    id: networkRow
    property var connection
    property bool isActive: false
    property bool showConnect: false
    property bool showDisconnect: false
    property bool showPasswordField: false
    property string password: ""

    width: parent.width
    implicitHeight: mainLayout.implicitHeight

    function signalIcon(strength, secure) {
        if (!connection) return "network_wifi";
        if (connection.type === "ethernet") return "settings_ethernet";
        if (strength >= 75) return "network_wifi";
        if (strength >= 50) return "network_wifi_3_bar";
        if (strength >= 25) return "network_wifi_2_bar";
        if (strength > 0)   return "network_wifi_1_bar";
        return "network_wifi_1_bar";
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: Metrics.spacing(10)

        RowLayout {
            spacing: Metrics.spacing(10)

            // Signal icon with lock overlay
            Item {
                width: Metrics.spacing(32)
                height: Metrics.spacing(32)

                MaterialSymbol {
                    anchors.fill: parent
                    icon: connection ? signalIcon(connection.strength, connection.isSecure) : "network_wifi"
                    font.pixelSize: Metrics.fontSize(32)
                }

                // Lock overlay (anchors are safe because Item is not layout-managed)
                MaterialSymbol {
                    icon: "lock"
                    visible: connection && connection.type === "wifi" && connection.isSecure
                    font.pixelSize: Metrics.fontSize(12)
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: Metrics.spacing(0)

                StyledText {
                    text: connection ? connection.name : ""
                    font.pixelSize: Metrics.fontSize(16)
                    font.bold: true
                }

                StyledText {
                    text: connection ? (
                        isActive ? "Connected" :
                        connection.type === "ethernet" ? connection.device || "Ethernet" :
                        connection.isSecure ? "Secured" : "Open"
                    ) : ""
                    font.pixelSize: Metrics.fontSize(12)
                    color: isActive
                        ? Appearance.m3colors.m3primary
                        : ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.4)
                }
            }

            Item { Layout.fillWidth: true }

            StyledButton {
                visible: showConnect && !showPasswordField
                icon: "link"
                onClicked: {
                    if (!connection) return;
                    if (connection.type === "ethernet") Network.connect(connection, "")
                    else if (connection.isSecure) showPasswordField = true
                    else Network.connect(connection, "")
                }
            }

            StyledButton {
                visible: showDisconnect && !showPasswordField
                icon: "link_off"
                onClicked: Network.disconnect()
            }
        }

        // Password row
        RowLayout {
            visible: showPasswordField && connection && connection.type === "wifi"
            spacing: Metrics.spacing(10)

            StyledTextField {
                padding: Metrics.padding(10)
                Layout.fillWidth: true
                placeholderText: "Enter password"
                echoMode: parent.showPassword ? TextInput.Normal : TextInput.Password
                onTextChanged: networkRow.password = text
                onAccepted: {
                    if (!connection) return;
                    Network.connect(connection, networkRow.password)
                    showPasswordField = false
                }
            }

            StyledButton {
                property bool showPassword: false
                icon: parent.showPassword ? "visibility" : "visibility_off"
                onClicked: parent.showPassword = !parent.showPassword
            }

            StyledButton {
                icon: "link"
                onClicked: {
                    if (!connection) return;
                    Network.connect(connection, networkRow.password)
                    showPasswordField = false
                }
            }
        }
    }
}
