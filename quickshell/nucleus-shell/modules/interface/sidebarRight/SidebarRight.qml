import qs.config
import qs.modules.components
import qs.modules.functions
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

PanelWindow {
    id: sidebarRight

    WlrLayershell.namespace: "nucleus:sidebarRight"
    WlrLayershell.layer: WlrLayer.Top

    color: "transparent"
    exclusiveZone: 0

    visible: Config.initialized
             && Globals.visiblility.sidebarRight
             && !Globals.visiblility.sidebarLeft

    WlrLayershell.keyboardFocus:
        Compositor.require("niri") && Globals.visiblility.sidebarRight


    property real sidebarRightWidth: 500


    implicitWidth: Compositor.screenW


    HyprlandFocusGrab {
        id: grab
        active: Compositor.require("hyprland")
        windows: [sidebarRight]
    }


    anchors {
        top: true
        bottom: true

        right: Config.runtime.bar.position !== "left"
        left: Config.runtime.bar.position === "left"
    }


    margins {
        top: Config.runtime.bar.margins
        bottom: Config.runtime.bar.margins
        left: Metrics.margin("small")
        right: Metrics.margin("small")
    }


    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    MouseArea {
        anchors.fill: parent
        z: 0

        onPressed: {
            Globals.visiblility.sidebarRight = false
        }
    }


    StyledRect {
        id: container

        z: 1
        width: sidebarRight.sidebarRightWidth

        color: Appearance.m3colors.m3background
        radius: Metrics.radius("large")

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }


        MouseArea {
            anchors.fill: parent
            onPressed: mouse.accepted = true
        }


        FocusScope {
            anchors.fill: parent
            focus: true


            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    Globals.visiblility.sidebarRight = false
                }
            }


            SidebarRightContent {}
        }
    }


    function toggleSidebarRight() {
        Globals.visiblility.sidebarRight =
            !Globals.visiblility.sidebarRight
    }


    IpcHandler {
        target: "sidebarRight"

        function toggle() {
            toggleSidebarRight()
        }
    }
}
