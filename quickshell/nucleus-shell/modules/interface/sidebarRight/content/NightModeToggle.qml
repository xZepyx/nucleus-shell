import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import qs.services
import qs.config
import qs.modules.components

Rectangle {
    id: root

    property bool nightTime: false

    width: 84
    height: 84

    radius: Metrics.radius("childish")

    color: nightTime
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

        icon: "bedtime"
        iconSize: Metrics.iconSize(34)

        color: nightTime
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
            root.nightTime = !root.nightTime

            if (root.nightTime)
                Quickshell.execDetached(["gammastep","-O","4000"])
            else
                Quickshell.execDetached(["killall","gammastep"])
        }
    }
}
