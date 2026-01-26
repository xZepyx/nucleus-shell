import qs.config
import qs.modules.widgets
import qs.services
import qs.modules.functions
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: sidebarRight
    WlrLayershell.namespace: "nucleus:sidebarleft"
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.sidebarRight && !Globals.visiblility.sidebarLeft

    color: "transparent"
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor


    property real sidebarRightWidth: 500

    implicitWidth: sidebarRightWidth

    anchors {
        top: true
        right: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom")
        bottom: true
        left: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right")
    }

    margins {
        top: Config.runtime.bar.margins
        bottom: Config.runtime.bar.margins
        left: Appearance.margin.small
        right: Appearance.margin.small
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    StyledRect {
        id: container
        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.large
        implicitWidth: sidebarRight.sidebarRightWidth

        anchors.fill: parent

        SidebarRightContent{}

    }

    // --- Toggle logic ---
    function togglesidebarRight() {
        Globals.visiblility.sidebarRight = !Globals.visiblility.sidebarRight
    }

    IpcHandler {
        target: "sidebarRight"
        function toggle() {
            togglesidebarRight()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            sidebarRight.monitor = Hyprland.focusedMonitor
        }
    }
}
