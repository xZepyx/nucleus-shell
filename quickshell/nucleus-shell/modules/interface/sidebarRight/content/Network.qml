import qs.config
import qs.modules.components
import qs.modules.functions
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts

StyledRect {
    id: root
    width: 150
    height: 50
    radius: Metrics.radius("verylarge")
    color: Appearance.m3colors.m3surfaceContainerHigh

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    // Service bindings 
    readonly property bool wifiEnabled: Network.wifiEnabled
    readonly property bool hasActive: Network.active !== null
    readonly property string iconName: Network.icon
    readonly property string titleText: Network.label
    readonly property string statusText: Network.status

    // Icon background 
    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: Metrics.radius("large")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Metrics.margin(10)

        color: {
            if (!wifiEnabled)
                return Appearance.m3colors.m3surfaceContainerHigh;
            if (hasActive)
                return Appearance.m3colors.m3primaryContainer;
            return Appearance.m3colors.m3secondaryContainer;
        }

        MaterialSymbol {
            anchors.centerIn: parent
            icon: iconName
            iconSize: Metrics.iconSize(35)
        }
    }

    // Labels 
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: Metrics.margin(10)
        spacing: Metrics.spacing(2)

        StyledText {
            text: titleText
            font.pixelSize: Metrics.fontSize(20)
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

    // Interaction 
    MouseArea {
        anchors.fill: parent
        onClicked: Network.toggleWifi()
    }
}
