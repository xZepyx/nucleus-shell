import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.modules.components

Scope {
    id: root

    GothCorners {
        opacity: Config.runtime.bar.gothCorners && !Config.runtime.bar.floating && Config.runtime.bar.enabled && !Config.runtime.bar.merged ? 1 : 0
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            property int rd: Config.runtime.bar.radius * Config.runtime.appearance.rounding.factor
            property int margin: Config.runtime.bar.margins
            property bool floating: Config.runtime.bar.floating
            property bool merged: Config.runtime.bar.merged
            property string pos: Config.runtime.bar.position
            property bool vertical: pos === "left" || pos === "right"
            property bool pillOnly: Config.runtime.bar.pillOnly ?? true

            property bool attachedTop: pos === "top"
            property bool attachedBottom: pos === "bottom"
            property bool attachedLeft: pos === "left"
            property bool attachedRight: pos === "right"

            screen: modelData
            visible: Config.runtime.bar.enabled && Config.initialized
            WlrLayershell.namespace: "nucleus:bar"

            exclusiveZone: Config.runtime.bar.floating
                ? Config.runtime.bar.density + Metrics.margin("tiny")
                : Config.runtime.bar.density

            implicitHeight: Config.runtime.bar.density
            implicitWidth: Config.runtime.bar.density
            color: "transparent"

            anchors {
                top: Config.runtime.bar.position === "top" || Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right"
                bottom: Config.runtime.bar.position === "bottom" || Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right"
                left: Config.runtime.bar.position === "left" || Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom"
                right: Config.runtime.bar.position === "right" || Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom"
            }

            margins {
                top: {
                    if (floating)
                        return margin
                    if (merged && vertical)
                        return margin
                    return 0
                }
                bottom: {
                    if (floating)
                        return margin
                    if (merged && vertical)
                        return margin
                    return 0
                }
                left: {
                    if (floating)
                        return margin
                    if (merged && !vertical)
                        return margin
                    return 0
                }
                right: {
                    if (floating)
                        return margin
                    if (merged && !vertical)
                        return margin
                    return 0
                }
            }

            StyledRect {
                id: background
                color: pillOnly ? "transparent" : Appearance.m3colors.m3background
                anchors.fill: parent

                topLeftRadius: {
                    if (floating)
                        return rd
                    if (!merged)
                        return 0
                    return attachedBottom || attachedRight ? rd : 0
                }

                topRightRadius: {
                    if (floating)
                        return rd
                    if (!merged)
                        return 0
                    return attachedBottom || attachedLeft ? rd : 0
                }

                bottomLeftRadius: {
                    if (floating)
                        return rd
                    if (!merged)
                        return 0
                    return attachedTop || attachedRight ? rd : 0
                }

                bottomRightRadius: {
                    if (floating)
                        return rd
                    if (!merged)
                        return 0
                    return attachedTop || attachedLeft ? rd : 0
                }

                BarContent {
                    anchors.fill: parent
                }

                Behavior on bottomLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on bottomRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }
            }
        }
    }
}
