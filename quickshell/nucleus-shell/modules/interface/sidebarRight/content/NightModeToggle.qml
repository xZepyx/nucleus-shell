import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.modules.components

Rectangle {
    id: root

    property bool nightTime
    width: 200
    height: 80
    radius: Metrics.radius("childish")
    color: !nightTime ? Appearance.m3colors.m3surfaceContainer : Appearance.m3colors.m3paddingContainer
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    MaterialSymbol {
        anchors.centerIn: parent
        iconSize: Metrics.iconSize(35)
        icon: "coffee"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            nightTime = !nightTime;
            nightTime ? Quickshell.execDetached(["gammastep", "-O", "4000"]) : Quickshell.execDetached(["killall", "gammastep"]);
        }
    }

}
