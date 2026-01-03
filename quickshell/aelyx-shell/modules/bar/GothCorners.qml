import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.widgets

PanelWindow {
    id: root

    color: "transparent"
    visible: Shell.ready
    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    Item {
        id: container

        anchors.fill: parent

        StyledRect {
            anchors.fill: parent
            color: Appearance.m3colors.m3background
            layer.enabled: true

            layer.effect: MultiEffect {
                maskSource: mask
                maskEnabled: true
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }

        }

        Item {
            id: mask

            anchors.fill: parent
            layer.enabled: true
            visible: false

            StyledRect {
                anchors.fill: parent
                anchors.topMargin: Shell.flags.bar.position === "bottom" ? -15 : 0
                anchors.bottomMargin: Shell.flags.bar.position === "top" ? -15 : 0
                anchors.leftMargin: Shell.flags.bar.position === "right" ? -15 : 0
                anchors.rightMargin: Shell.flags.bar.position === "left" ? -15 : 0
                radius: Appearance.rounding.normal
            }

        }

    }

    mask: Region {
        item: container
        intersection: Intersection.Xor
    }

}
