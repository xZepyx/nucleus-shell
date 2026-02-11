import QtQuick
import Quickshell
import qs.config

MaterialSymbol {
    id: root

    // Expose mouse props
    property alias enabled: ma.enabled
    property alias hoverEnabled: ma.hoverEnabled
    property alias pressed: ma.pressed
    property string tooltipText: ""

    // Renamed signals (no collisions possible)
    signal buttonClicked()
    signal buttonEntered()
    signal buttonExited()
    signal buttonPressAndHold()
    signal buttonPressedChanged(bool pressed)

    MouseArea {
        id: ma

        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.buttonClicked()
        onEntered: root.buttonEntered()
        onExited: root.buttonExited()
        onPressAndHold: root.buttonPressAndHold()
        onPressedChanged: root.buttonPressedChanged(pressed)
    }

    HoverHandler {
        id: hover

        enabled: root.tooltipText !== ""
    }

    LazyLoader {
        active: root.tooltipText !== ""
        StyledPopout {
            hoverTarget: hover
            hoverDelay: Metrics.chronoDuration(500)

            Component {
                StyledText {
                    text: root.tooltipText
                }

            }

        }

    }

}
