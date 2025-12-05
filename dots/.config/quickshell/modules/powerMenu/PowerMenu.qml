import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services
import qs.settings
import qs.widgets

Scope {
    id: root

    PanelWindow {
        id: powerMenu

        property var monitor: Hyprland.focusedMonitor
        property real screenW: monitor ? monitor.width : 0
        property real screenH: monitor ? monitor.height : 0
        property real scale: monitor ? monitor.scale : 1
        property real powerMenuWidth: screenW * 0.245 / scale
        property real powerMenuHeight: screenH * 0.31 / scale

        function togglepowerMenu() {
            GlobalStates.powerMenuOpen = !GlobalStates.powerMenuOpen;
        }

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: GlobalStates.powerMenuOpen
        visible: Shell.ready
        color: "transparent"
        focusable: true
        exclusiveZone: 0

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        Rectangle {
            id: overlay

            anchors.fill: parent
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                enabled: GlobalStates.powerMenuOpen
                onClicked: {
                    GlobalStates.powerMenuOpen = false;
                }
            }

            Behavior on opacity {
                Anim {
                }

            }

        }

        MergedEdgeRect {
            id: container

            visible: implicitHeight > 0
            color: Appearance.m3colors.m3background
            cornerRadius: Appearance.rounding.verylarge
            implicitWidth: GlobalStates.powerMenuOpen ? powerMenu.powerMenuWidth : 0
            implicitHeight: GlobalStates.powerMenuOpen ? powerMenu.powerMenuHeight : 0
            opacity: GlobalStates.powerMenuOpen ? 1 : 0

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Behavior on implicitHeight {
                Anim {
                }

            }

            Behavior on implicitWidth {
                Anim {
                }

            }

            Behavior on opacity {
                Anim {
                }

            }

            content: Item {
                anchors.fill: parent

                Grid {
                    columns: 3
                    rows: 3
                    rowSpacing: 10
                    columnSpacing: 10
                    anchors.fill: parent

                    PowerMenuButton {
                        buttonIcon: "power_settings_new"
                        onClicked: Quickshell.execDetached(["poweroff"])
                    }

                    PowerMenuButton {
                        buttonIcon: "logout"
                        onClicked: Quickshell.execcDetached(["hyprctl", "dispatch", "exit"])
                    }

                    PowerMenuButton {
                        buttonIcon: "sleep"
                        onClicked: Quickshell.execDetached(["systemctl", "suspend"])
                    }

                    PowerMenuButton {
                        buttonIcon: "lock"
                        onClicked: Quickshell.execDetached(["hyprlock"])
                    }

                    PowerMenuButton {
                        buttonIcon: "restart_alt"
                        onClicked: Quickshell.execDetached(["reboot"])
                    }

                    PowerMenuButton {
                        buttonIcon: "light_off"
                        onClicked: Quickshell.execDetached(["systemctl", "hibernate"])
                    }

                }

            }

        }

        IpcHandler {
            function toggle() {
                togglepowerMenu();
            }

            target: "powerMenu"
        }

        Connections {
            function onFocusedMonitorChanged() {
                powerMenu.monitor = Hyprland.focusedMonitor;
            }

            target: Hyprland
        }

        component Anim: NumberAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.curves.standard
        }

        mask: Region {
            item: overlay
            intersection: GlobalStates.powerMenuOpen ? Intersection.Combine : Intersection.Xor
        }

        component PowerMenuButton: StyledButton {
            property string buttonIcon
            icon: buttonIcon
            icon_size: 50
            width: powerMenu.implicitWidth * 1.3
            height: powerMenu.implicitHeight * 1.3
            radius: beingHovered ? Appearance.rounding.verylarge + 40 : Appearance.rounding.verylarge

        }

    }

}
