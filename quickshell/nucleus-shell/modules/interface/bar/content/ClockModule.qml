import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.components

Item {
    id: clockContainer

    property string format: isVertical ? "hh\nmm\nAP" : "hh:mm • dd/MM"
    property bool isVertical: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right")

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // Let the layout compute size automatically

    Rectangle {
        id: bgRect

        color: isVertical ? "transparent" : Appearance.m3colors.m3paddingContainer
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        // Padding around the text
        implicitWidth: isVertical ? textItem.implicitWidth + 40 : textItem.implicitWidth + Metrics.margin("large")
        implicitHeight: Config.runtime.bar.modules.height
    }

    StyledText {
        id: textItem
        anchors.centerIn: parent
        animate: false
        text: Time.format(clockContainer.format)
    }

}
