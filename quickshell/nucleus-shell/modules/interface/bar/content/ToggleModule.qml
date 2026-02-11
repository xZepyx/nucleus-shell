import qs.config
import qs.modules.components
import QtQuick
import Quickshell
import QtQuick.Layouts

StyledRect {
    id: bg

    property string icon
    property color iconColor: Appearance.syntaxHighlightingTheme
    property int iconSize
    property bool toggle
    property bool transparentBg: false

    signal toggled(bool value)

    color: (ma.containsMouse && !transparentBg)
        ? Appearance.m3colors.m3paddingContainer
        : "transparent"

    radius: Metrics.radius("childish")

    implicitWidth: textItem.implicitWidth + 12
    implicitHeight: textItem.implicitHeight + 6

    MaterialSymbol {
        id: textItem
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0.4
        anchors.horizontalCenterOffset: 0.499
        iconSize: bg.iconSize
        icon: bg.icon
        color: bg.iconColor
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: bg.toggled(!bg.toggle)
    }
}
