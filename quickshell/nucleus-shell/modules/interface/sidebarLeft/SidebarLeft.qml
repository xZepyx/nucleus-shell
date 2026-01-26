import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.modules.functions
import qs.config
import qs.modules.widgets

PanelWindow {
    id: sidebarLeft
    WlrLayershell.namespace: "nucleus:sidebarleft"
    // --- Directly use Hyprland's focused monitor ---
    property real sidebarLeftWidth: 500

    // --- Toggle logic ---
    function togglesidebarLeft() {
        Globals.visiblility.sidebarLeft = !Globals.visiblility.sidebarLeft;
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.sidebarLeft && !Globals.visiblility.sidebarRight
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: sidebarLeftWidth

    HyprlandFocusGrab {
      id: grab
      active: true
      windows: [ sidebarLeft ]
    }

    anchors {
        top: true
        left: true
        bottom: true
    }

    margins {
        top: 10
        bottom: 10
        left: Appearance.margin.small
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.normal
        implicitWidth: sidebarLeft.sidebarLeftWidth
        anchors.fill: parent

        SidebarLeftContent { }

    }

    IpcHandler {
        function toggle() {
            togglesidebarLeft();
        }

        target: "sidebarLeft"
    }

}