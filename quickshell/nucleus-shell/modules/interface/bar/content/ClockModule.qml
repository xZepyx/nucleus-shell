import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.components

Item {
    id: clockContainer

    property string format: isVertical ? "hh\nmm\nAP" : "hh:mm • dd/MM"
    property bool isVertical: (ConfigResolver.bar(screen?.name ?? "").position === "left" || ConfigResolver.bar(screen?.name ?? "").position === "right")

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // Let the layout compute size automatically

    Rectangle {
        id: bgRect

        color: isVertical ? "transparent" : Appearance.m3colors.m3paddingContainer
        radius: ConfigResolver.bar(screen?.name ?? "").modules.radius * Config.runtime.appearance.rounding.factor
        // Padding around the text
        implicitWidth: isVertical ? textItem.implicitWidth + 40 : textItem.implicitWidth + Metrics.margin("large")
        implicitHeight: ConfigResolver.bar(screen?.name ?? "").modules.height
    }

    StyledText {
        id: textItem
        anchors.centerIn: parent
        animate: false
        text: Time.format(clockContainer.format)
    }

}
