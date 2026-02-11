import qs.config
import qs.modules.components
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts

StyledRect {
    id: root
    width: 200
    height: 80
    radius: Metrics.radius("verylarge")
    color: Appearance.m3colors.m3surfaceContainerHigh

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    readonly property bool adapterPresent: Bluetooth.defaultAdapter !== null
    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property var activeDevice: Bluetooth.activeDevice

    readonly property string iconName: Bluetooth.icon

    readonly property string statusText: {
        if (!adapterPresent)
            return "No adapter";
        if (!enabled)
            return "Disabled";
        if (activeDevice)
            return activeDevice.name;
        return Bluetooth.defaultAdapter.discovering
            ? "Scanning…"
            : "Enabled";
    }

    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: Metrics.radius("verylarge")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Metrics.margin("small")

        color: {
            if (!enabled)
                return Appearance.m3colors.m3surfaceContainerHigh;
            if (activeDevice)
                return Appearance.m3colors.m3primaryContainer;
            return Appearance.m3colors.m3secondaryContainer;
        }

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: Metrics.iconSize(35)
            icon: iconName
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: Metrics.margin("small")
        spacing: Metrics.spacing(2)

        StyledText {
            text: "Bluetooth"
            font.pixelSize: Metrics.fontSize("large")
            elide: Text.ElideRight
            width: root.width - iconBg.width - 30
        }

        StyledText {
            text: statusText
            font.pixelSize: Metrics.fontSize("small")
            color: Appearance.m3colors.m3onSurfaceVariant
            elide: Text.ElideRight
            width: root.width - iconBg.width - 30
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!adapterPresent)
                return;

            Bluetooth.defaultAdapter.enabled =
                !Bluetooth.defaultAdapter.enabled;
        }
    }
}
