import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.modules.functions
import qs.modules.widgets

PanelWindow {
    id: sidebarLeft

    // --- Directly use Hyprland's focused monitor ---
    property real sidebarLeftWidth: 500

    // --- Toggle logic ---
    function togglesidebarLeft() {
        Globals.visiblility.sidebarLeft = !Globals.visiblility.sidebarLeft;
    }

    WlrLayershell.namespace: "nucleus:sidebarleft"
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.sidebarLeft && !Globals.visiblility.sidebarRight
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: sidebarLeftWidth
    focus: Compositor.require("niri")
    WlrLayershell.keyboardFocus: Compositor.require("niri") && Globals.visiblility.sidebarRight

    HyprlandFocusGrab {
        id: grab

        active: Compositor.require("hyprland")
        windows: [sidebarLeft]
    }

    anchors {
        top: true
        left: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "bottom" || Config.runtime.bar.position === "top")
        bottom: true
        right: (Config.runtime.bar.position === "right")
    }

    margins {
        top: 10
        bottom: 10
        right: Appearance.margin.small
        left: Appearance.margin.small
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.normal
        implicitWidth: sidebarLeft.sidebarLeftWidth
        anchors.fill: parent
        FocusScope {
            focus: true 
            anchors.fill: parent
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    Globals.visiblility.sidebarLeft = false;
                }
            }
            SidebarLeftContent {
            }
        }
    }

    IpcHandler {
        function toggle() {
            togglesidebarLeft();
        }

        target: "sidebarLeft"
    }

}
