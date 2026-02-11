import QtQuick
import Quickshell
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    readonly property double durationScale: Config.runtime.appearance.animations.durationScale
    readonly property double roundingScale: Config.runtime.appearance.rounding.factor
    readonly property double fontScale: Config.runtime.appearance.font.scale

    function spacing(value) { // These will be used with a scale later on...
        return value
    }

    function padding(value) {
        return value
    }

    function chronoDuration(value) {
        if (typeof value === "number")
            return value * durationScale

        switch (value) {
            case "supershort":               return Appearance.animation.durations.supershort * durationScale
            case "small":                    return Appearance.animation.durations.small * durationScale
            case "normal":                   return Appearance.animation.durations.normal * durationScale
            case "large":                    return Appearance.animation.durations.large * durationScale
            case "extraLarge":               return Appearance.animation.durations.extraLarge * durationScale
            case "expressiveFastSpatial":    return Appearance.animation.durations.expressiveFastSpatial * durationScale
            case "expressiveDefaultSpatial": return Appearance.animation.durations.expressiveDefaultSpatial * durationScale
            case "expressiveEffects":        return Appearance.animation.durations.expressiveEffects * durationScale
            default:                         return 0
        }
    }

    function margin(value) {
        if (typeof value === "number")
            return value

        switch (value) {
            case "supertiny":  return Appearance.margin.supertiny
            case "tinier":     return Appearance.margin.tinier
            case "tiny":       return Appearance.margin.tiny
            case "verysmall":  return Appearance.margin.verysmall
            case "small":      return Appearance.margin.small
            case "normal":     return Appearance.margin.normal
            case "large":      return Appearance.margin.large
            case "verylarge":  return Appearance.margin.verylarge
            case "extraLarge": return Appearance.margin.extraLarge
            default:           return 0
        }
    }

    function radius(value) {
        if (typeof value === "number")
            return value * roundingScale

        switch (value) {
            case "unsharpen":       return Appearance.rounding.unsharpen * roundingScale
            case "unsharpenmore":   return Appearance.rounding.unsharpenmore * roundingScale
            case "verysmall":       return Appearance.rounding.verysmall * roundingScale
            case "small":           return Appearance.rounding.small * roundingScale
            case "normal":          return Appearance.rounding.normal * roundingScale
            case "large":           return Appearance.rounding.large * roundingScale
            case "verylarge":       return Appearance.rounding.verylarge * roundingScale
            case "childish":        return Appearance.rounding.childish * roundingScale
            case "full":            return Appearance.rounding.full * roundingScale
            case "screenRounding":  return Appearance.rounding.screenRounding * roundingScale
            case "windowRounding":  return Appearance.rounding.windowRounding * roundingScale
            default:                return 0
        }
    }

    function fontSize(value) {
        if (typeof value === "number")
            return value * fontScale

        switch (value) {
            case "smallest": return Appearance.font.size.smallest * fontScale
            case "smaller":  return Appearance.font.size.smaller * fontScale
            case "smallie":  return Appearance.font.size.smallie * fontScale
            case "small":    return Appearance.font.size.small * fontScale
            case "normal":   return Appearance.font.size.normal * fontScale
            case "large":    return Appearance.font.size.large * fontScale
            case "larger":   return Appearance.font.size.larger * fontScale
            case "big":      return Appearance.font.size.big * fontScale
            case "huge":     return Appearance.font.size.huge * fontScale
            case "hugeass":  return Appearance.font.size.hugeass * fontScale
            case "wildass":  return Appearance.font.size.wildass * fontScale
            case "title":    return Appearance.font.size.title * fontScale
            default:         return Appearance.font.size.normal * fontScale
        }
    }

    function iconSize(value) {
        if (typeof value === "number")
            return value * fontScale

        switch (value) {
            case "smallest": return Appearance.font.size.icon.smallest * fontScale
            case "smaller":  return Appearance.font.size.icon.smaller * fontScale
            case "smallie":  return Appearance.font.size.icon.smallie * fontScale
            case "small":    return Appearance.font.size.icon.small * fontScale
            case "normal":   return Appearance.font.size.icon.normal * fontScale
            case "large":    return Appearance.font.size.icon.large * fontScale
            case "larger":   return Appearance.font.size.icon.larger * fontScale
            case "big":      return Appearance.font.size.icon.big * fontScale
            case "huge":     return Appearance.font.size.icon.huge * fontScale
            case "hugeass":  return Appearance.font.size.icon.hugeass * fontScale
            case "wildass":  return Appearance.font.size.icon.wildass * fontScale
            case "title":    return Appearance.font.size.icon.title * fontScale
            default:         return Appearance.font.size.icon.normal * fontScale
        }
    }

    function fontFamily(value) {
        if (typeof value === "string") {
            switch (value) {
                case "main":          return Appearance.font.family.main
                case "title":         return Appearance.font.family.title
                case "materialIcons": return Appearance.font.family.materialIcons
                case "nerdIcons":     return Appearance.font.family.nerdIcons
                case "monospace":     return Appearance.font.family.monospace
                case "reading":       return Appearance.font.family.reading
                case "expressive":    return Appearance.font.family.expressive
                default:              return value
            }
        }
        return Appearance.font.family.main
    }
}
