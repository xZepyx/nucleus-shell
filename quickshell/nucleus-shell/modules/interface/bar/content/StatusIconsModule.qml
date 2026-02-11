import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.components
import qs.services

Item {
    id: statusIconsContainer

    property bool isVertical: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right")

    Layout.alignment: Qt.AlignVCenter
    visible: Config.runtime.bar.modules.statusIcons.enabled
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    StyledRect {
        id: bgRect

        color: Globals.visiblility.sidebarRight ? Appearance.m3colors.m3paddingContainer : "transparent"
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: isVertical ? contentRow.implicitWidth + Metrics.margin("large") - 8 : contentRow.implicitWidth + Metrics.margin("large")
        implicitHeight: Config.runtime.bar.modules.height

        RowLayout {
            id: contentRow

            anchors.centerIn: parent
            spacing: isVertical ? Metrics.spacing(8) : Metrics.spacing(16)


            MaterialSymbol {
                id: wifi
                animate: false
                visible: Config.runtime.bar.modules.statusIcons.networkStatusEnabled
                rotation: isVertical ? 270 : 0
                icon: Network.icon
                iconSize: Metrics.fontSize("huge")
            }

            MaterialSymbol {
                id: btIcon
                animate: false
                visible: Config.runtime.bar.modules.statusIcons.bluetoothStatusEnabled
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
