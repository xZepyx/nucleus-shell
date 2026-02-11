import QtQuick
import qs.config

StyledText {
    property string icon: ""
    property int fill: 0
    property int iconSize: Metrics.iconSize("large")

    font.family: Appearance.font.family.materialIcons
    font.pixelSize: iconSize
    text: icon
    font.variableAxes: {
        "FILL": fill
    }
}
