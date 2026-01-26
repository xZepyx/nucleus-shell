import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.widgets
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

        color: Appearance.m3colors.m3errorContainer
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: isVertical ? contentRow.implicitWidth + Appearance.margin.large - 8 : contentRow.implicitWidth + Appearance.margin.large
        implicitHeight: Config.runtime.bar.modules.height

        RowLayout {
            id: contentRow

            anchors.centerIn: parent
            spacing: isVertical ? 2 : 8

            MaterialSymbol {
                id: themeIcon

                visible: Config.runtime.bar.modules.statusIcons.themeStatusEnabled
                rotation: isVertical ? 270 : 0
                fill: 1
                icon: Config.runtime.appearance.theme === "light" ? "light_mode" : "dark_mode"
                iconSize: Appearance.font.size.huge
            }

            MaterialSymbol {
                id: wifi

                visible: Config.runtime.bar.modules.statusIcons.networkStatusEnabled
                rotation: isVertical ? 270 : 0
                icon: Network.icon
                iconSize: Appearance.font.size.huge
            }

            MaterialSymbol {
                id: btIcon

                visible: Config.runtime.bar.modules.statusIcons.bluetoothStatusEnabled
                rotation: isVertical ? 270 : 0
                icon: Bluetooth.icon
                iconSize: Appearance.font.size.huge
            }

            StyledText {
                id: keyboardLayoutIcon

                visible: Config.runtime.bar.modules.statusIcons.keyboardLayoutStatusEnabled
                rotation: isVertical ? 270 : 0
                text: SystemDetails.keyboardLayout
                font.pixelSize: Appearance.font.size.huge - 4
                Layout.leftMargin: isVertical ? 0 : -3
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
