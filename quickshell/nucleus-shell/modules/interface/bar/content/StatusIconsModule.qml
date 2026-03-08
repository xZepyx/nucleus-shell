import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.components
import qs.services

Item {
    id: statusIconsContainer

    property bool isVertical: (ConfigResolver.bar(screen?.name ?? "").position === "left" || ConfigResolver.bar(screen?.name ?? "").position === "right")

    Layout.alignment: Qt.AlignVCenter
    visible: ConfigResolver.bar(screen?.name ?? "").modules.statusIcons.enabled
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    StyledRect {
        id: bgRect

        color: Globals.visiblility.sidebarRight ? Appearance.m3colors.m3paddingContainer : "transparent"
        radius: ConfigResolver.bar(screen?.name ?? "").modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: isVertical ? contentRow.implicitWidth + Metrics.margin("large") - 8 : contentRow.implicitWidth + Metrics.margin("large")
        implicitHeight: ConfigResolver.bar(screen?.name ?? "").modules.height

        RowLayout {
            id: contentRow

            anchors.centerIn: parent
            spacing: isVertical ? Metrics.spacing(8) : Metrics.spacing(16)


            MaterialSymbol {
                id: wifi
                animate: false
                visible: ConfigResolver.bar(screen?.name ?? "").modules.statusIcons.networkStatusEnabled
                rotation: isVertical ? 270 : 0
                icon: Network.icon
                iconSize: Metrics.fontSize("huge")
            }

            MaterialSymbol {
                id: btIcon
                animate: false
                visible: ConfigResolver.bar(screen?.name ?? "").modules.statusIcons.bluetoothStatusEnabled
                rotation: isVertical ? 270 : 0
                icon: Bluetooth.icon
                iconSize: Metrics.fontSize("huge")
            }


        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (Globals.visiblility.sidebarLeft)
                    return
                Globals.visiblility.sidebarRight = !Globals.visiblility.sidebarRight
            }
        }

    }

}
