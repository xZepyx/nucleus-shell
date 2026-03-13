import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import qs.services
import qs.config
import qs.modules.components

Rectangle {
    id: root

    readonly property bool isLight: Config.runtime.appearance.theme !== "dark"

    width: 84
    height: 84

    radius: Metrics.radius("childish")

    color: isLight
        ? Appearance.m3colors.m3primaryContainer
        : Appearance.m3colors.m3surfaceContainer

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Appearance.m3colors.m3shadow
        shadowBlur: 0.6
        shadowOpacity: 0.35
    }

    MaterialSymbol {
        anchors.centerIn: parent

        icon: "wb_sunny"
        iconSize: Metrics.iconSize(34)

        color: isLight
            ? Appearance.m3colors.m3onPrimaryContainer
            : Appearance.m3colors.m3onSurface
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius

        color: Appearance.m3colors.m3onSurface
        opacity: mouseArea.pressed ? 0.12
                : mouseArea.containsMouse ? 0.08
                : 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            Quickshell.execDetached([
                "nucleus",
                "ipc",
                "call",
                "global",
                "toggleTheme"
            ])
        }
    }
}
