import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.services
import qs.modules.functions
import qs.modules.components

PanelWindow {
    id: sidebarLeft

    property real sidebarLeftWidth: 500

    function togglesidebarLeft() {
        Globals.visiblility.sidebarLeft = !Globals.visiblility.sidebarLeft;
    }

    WlrLayershell.namespace: "nucleus:sidebarLeft"
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.sidebarLeft && !Globals.visiblility.sidebarRight
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: sidebarLeftWidth
    WlrLayershell.keyboardFocus: Compositor.require("niri") && Globals.visiblility.sidebarLeft

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
        top: Metrics.margin("small")
        bottom: Metrics.margin("small")
        right: Metrics.margin("small")
        left: Metrics.margin("small")
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Metrics.radius("normal")
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
