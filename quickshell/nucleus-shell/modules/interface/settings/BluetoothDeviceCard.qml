import QtQuick
import QtQuick.Layouts
import qs.modules.components 
import qs.config
import qs.modules.functions
import Quickshell.Bluetooth as QsBluetooth

ContentRowCard {
    id: deviceRow
    property var device
    property string statusText: ""
    property bool usePrimary: false
    property bool showConnect: false
    property bool showDisconnect: false
    property bool showPair: false
    property bool showRemove: false

    cardMargin: Metrics.margin(0)
    cardSpacing: Metrics.spacing(10)
    verticalPadding: Metrics.padding(0)
    opacity: device.state === QsBluetooth.BluetoothDeviceState.Connecting ||
             device.state === QsBluetooth.BluetoothDeviceState.Disconnecting ? 0.6 : 1

    function mapBluetoothIcon(dbusIcon, name) {
        console.log(dbusIcon, " / ", name)
        const iconMap = {
            "audio-headset": "headset",
            "audio-headphones": "headphones",
            "input-keyboard": "keyboard",
            "input-mouse": "mouse",
            "input-gaming": "sports_esports",
            "phone": "phone_android",
            "computer": "computer",
            "printer": "print",
            "camera": "photo_camera",
            "unknown": "bluetooth"
        }
        return iconMap[dbusIcon] || "bluetooth"
    }

    MaterialSymbol {
        icon: mapBluetoothIcon(device.icon, device.name)
        font.pixelSize: Metrics.fontSize(32)
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: Metrics.spacing(0)

        StyledText {
            text: device.name || device.address
            font.pixelSize: Metrics.fontSize(16)
            font.bold: true
        }

        StyledText {
            text: statusText
            font.pixelSize: Metrics.fontSize(12)
            color: usePrimary
                ? Appearance.m3colors.m3primary
                : ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.6)
        }
    }

    Item { Layout.fillWidth: true }

    StyledButton {
        visible: showConnect
        icon: "link"
        onClicked: device.connect()
    }

    StyledButton {
        visible: showDisconnect
        icon: "link_off"
        onClicked: device.disconnect()
    }

    StyledButton {
        visible: showPair
        icon: "add"
        onClicked: device.pair()
    }

    StyledButton {
        visible: showRemove
        icon: "delete"
        onClicked: Bluetooth.removeDevice(device)
    }
}
