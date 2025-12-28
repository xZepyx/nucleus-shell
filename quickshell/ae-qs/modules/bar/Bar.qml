import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.bar.widgets
import qs.settings
import qs.widgets

Scope {
    id: root

    GothCorners {
        visible: Shell.flags.bar.gothCorners && !Shell.flags.bar.floating && !Shell.flags.bar.floatingModules
    }

    Variants {
        model: Quickshell.screens

        StaticWindow {
            id: barWindow

            required property var modelData

            screen: modelData
            namespace: "aelyx:bar"
            visible: Shell.flags.bar.enabled
            implicitHeight: Shell.flags.bar.height

            anchors {
                top: Shell.flags.bar.atTop
                bottom: !Shell.flags.bar.atTop
                left: true
                right: true
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
