import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

PanelWindow {
    id: sidebarLeftOverlay

    visible: Globals.visiblility.sidebarLeft

    WlrLayershell.namespace: "nucleus:sidebarLeftOverlay"
    WlrLayershell.layer: WlrLayer.Overlay

    color: "transparent"
    exclusiveZone: -1

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onPressed: {
            Globals.visiblility.sidebarLeft = false
        }
    }
}