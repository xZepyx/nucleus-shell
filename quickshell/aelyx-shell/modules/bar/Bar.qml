import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.bar.widgets
import qs.config
import qs.widgets

Scope {
    id: root

    GothCorners {
        visible: Shell.flags.bar.gothCorners && !Shell.flags.bar.floating && !Shell.flags.bar.floatingModules && Shell.flags.bar.enabled
    }

    Variants {
        model: Quickshell.screens


        StaticWindow {
            // Pain in the ass to introduce verticalBar

            id: barWindow

            required property var modelData

            screen: modelData
            namespace: "aelyx:bar"
            visible: Shell.flags.bar.enabled
            implicitHeight: Shell.flags.bar.density
            implicitWidth: Shell.flags.bar.density


            anchors {
                top: Shell.flags.bar.position === "top" || Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right"
                bottom: Shell.flags.bar.position === "bottom" || Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right"
                left: Shell.flags.bar.position === "left" || Shell.flags.bar.position === "top" || Shell.flags.bar.position === "bottom"
                right: Shell.flags.bar.position === "right" || Shell.flags.bar.position === "top" || Shell.flags.bar.position === "bottom"
            }

            margins {
                top: (Shell.ready && Shell.flags.bar.floating) ? 10 : 0
                bottom: (Shell.ready && Shell.flags.bar.floating) ? 10 : 0
                left: (Shell.ready && Shell.flags.bar.floating) ? 10 : 0
                right: (Shell.ready && Shell.flags.bar.floating) ? 10 : 0
            }

            StyledRect {
                anchors.fill: parent
                radius: (Shell.ready && Shell.flags.bar.floating) ? Shell.flags.bar.radius : 0
                color: Appearance.m3colors.m3background
                opacity: Shell.flags.bar.floatingModules ? 0 : 1

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }

                }

            }

            BarContent {
                anchors.fill: parent
            }

        }

    }

}
