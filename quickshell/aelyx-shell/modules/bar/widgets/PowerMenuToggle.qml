import qs.config 
import qs.widgets 
import QtQuick 
import Quickshell
import QtQuick.Layouts

Rectangle {
    id: bgRect
    color: "transparent"
    radius: Appearance.rounding.full

    implicitWidth: textItem.implicitWidth + 12
    implicitHeight: textItem.implicitHeight + 12

    MaterialSymbol {
        id: textItem
        anchors.centerIn: parent         
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0.4
        anchors.horizontalCenter: parent.horizontalCenter       
        iconSize: 22
        icon: "power_settings_new"
        color: Appearance.m3colors.m3error
    }

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.powerMenuOpen = !GlobalStates.powerMenuOpen
    }

}
