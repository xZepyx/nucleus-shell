import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.config
import qs.widgets
import qs.services
import Quickshell
import Quickshell.Bluetooth

BarModule {
    id: root
    Layout.alignment: Qt.AlignVCenter

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    StyledRect {
        id: bgRect
        color: GlobalStates.sidebarRightOpen ? Appearance.m3colors.m3surfaceContainerHighest : "transparent"
        radius: Shell.flags.bar.moduleRadius 

        implicitWidth: contentRow.implicitWidth + Appearance.margin.large - 2
        implicitHeight: contentRow.implicitHeight + Appearance.margin.small - 2

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 14

            MaterialSymbol {
                rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                id: wifi
                icon: Network.signalStrength > 80 ? "network_wifi_3_bar" :
                      Network.signalStrength > 60 ? "network_wifi_2_bar" :
                      Network.signalStrength > 40 ? "network_wifi_1_bar" : "network_wifi_1_bar"
                iconSize: Appearance.font.size.huge
            }

            MaterialSymbol {
                rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                id: btIcon
                icon: "bluetooth"
                iconSize: Appearance.font.size.huge
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: updateIcon()
    }

    function updateIcon() {
        const adapter = Bluetooth.defaultAdapter;
        if (!adapter) {
            btIcon.text = "bluetooth_disabled";
            return;
        }
        const connectedDevice = adapter.devices.values.find(d => d.connected);
        btIcon.text = connectedDevice ? "bluetooth_connected" : "bluetooth";
    }

    Component.onCompleted: updateIcon()
}
