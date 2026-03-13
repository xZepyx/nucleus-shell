import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services
import qs.modules.components

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData

            screen: modelData
            property string displayName: modelData.name

            property var barConfig: ConfigResolver.bar(displayName)

            property int rd: barConfig.radius * Config.runtime.appearance.rounding.factor
            property int margin: barConfig.margins
            property bool floating: barConfig.floating
            property bool merged: barConfig.merged
            property string pos: barConfig.position

            property bool vertical: pos === "left" || pos === "right"

            property bool attachedTop: pos === "top"
            property bool attachedBottom: pos === "bottom"
            property bool attachedLeft: pos === "left"
            property bool attachedRight: pos === "right"

            visible: barConfig.enabled && Config.initialized

            WlrLayershell.namespace: "nucleus:bar"

            exclusiveZone: floating
                ? barConfig.density + Metrics.margin("tiny")
                : barConfig.density

            implicitHeight: barConfig.density
            implicitWidth: barConfig.density

            color: "transparent"

            anchors {
                top: pos === "top" || vertical
                bottom: pos === "bottom" || vertical
                left: pos === "left" || !vertical
                right: pos === "right" || !vertical
            }

            margins {
                top: floating || (merged && vertical) ? margin : 0
                bottom: floating || (merged && vertical) ? margin : 0
                left: floating || (merged && !vertical) ? margin : 0
                right: floating || (merged && !vertical) ? margin : 0
            }

            GothCorners {
                opacity: barConfig.gothCorners
                         && !barConfig.floating
                         && barConfig.enabled
                         && !barConfig.merged ? 1 : 0
            }

            StyledRect {
                id: background
                anchors.fill: parent
                color: Appearance.m3colors.m3background

                topLeftRadius: {
                    if (floating) return rd
                    if (!merged) return 0
                    return attachedBottom || attachedRight ? rd : 0
                }

                topRightRadius: {
                    if (floating) return rd
                    if (!merged) return 0
                    return attachedBottom || attachedLeft ? rd : 0
                }

                bottomLeftRadius: {
                    if (floating) return rd
                    if (!merged) return 0
                    return attachedTop || attachedRight ? rd : 0
                }

                bottomRightRadius: {
                    if (floating) return rd
                    if (!merged) return 0
                    return attachedTop || attachedLeft ? rd : 0
                }

                BarContent {
                    anchors.fill: parent
                }

                Behavior on topLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(background)
                }

                Behavior on topRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(background)
                }

                Behavior on bottomLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(background)
                }

                Behavior on bottomRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(background)
                }
            }
        }
    }
}
