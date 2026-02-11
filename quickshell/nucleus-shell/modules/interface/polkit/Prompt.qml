import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland

import qs.config
import qs.services
import qs.modules.components

PanelWindow {
    id: window
    property bool isClosing: false
    default property alias content: contentContainer.data
    signal fadeOutFinished()

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    color: "transparent"
    WlrLayershell.namespace: "nucleus:prompt"

    function closeWithAnimation() {
        if (isClosing) return
        isClosing = true
        fadeOutAnim.start()
    }

    Item {
        anchors.fill: parent

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                window.closeWithAnimation()
            }
        }

        ScreencopyView {
            id: screencopy
            visible: hasContent
            captureSource: window.screen
            anchors.fill: parent
            opacity: 0
            scale: 1
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1
                blurMax: 32
                brightness: -0.05
                layer.enabled: true
                layer.effect: MultiEffect {
                    autoPaddingEnabled: false
                    blurEnabled: true
                    blur: 1
                    blurMax: 32
                }
            }
        }

        NumberAnimation {
            id: fadeInAnim
            target: screencopy
            property: "opacity"
            from: 0
            to: 1
            duration: Metrics.chronoDuration("normal")
            easing.type: Appearance.animation.easing
            running: screencopy.visible && !window.isClosing
        }

        ParallelAnimation {
            id: scaleInAnim
            running: screencopy.visible && !window.isClosing
            NumberAnimation {
                target: contentContainer
                property: "scale"
                from: 0.9
                to: 1
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            ColorAnimation {
                target: window
                property: "color"
                from: "transparent"
                to: Appearance.m3colors.m3surface
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            NumberAnimation {
                target: contentContainer
                property: "opacity"
                from: 0
                to: 1
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
        }

        ParallelAnimation {
            id: fadeOutAnim
            NumberAnimation {
                target: screencopy
                property: "opacity"
                to: 0
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            ColorAnimation {
                target: window
                property: "color"
                to: "transparent"
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            NumberAnimation {
                target: contentContainer
                property: "opacity"
                to: 0
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            NumberAnimation {
                target: contentContainer
                property: "scale"
                to: 0.9
                duration: Metrics.chronoDuration("normal")
                easing.type: Appearance.animation.easing
            }
            onFinished: {
                window.visible = false
                window.fadeOutFinished()
            }
        }

        Item {
            id: contentContainer
            anchors.fill: parent
            opacity: 0
            scale: 0.9
        }
    }
}