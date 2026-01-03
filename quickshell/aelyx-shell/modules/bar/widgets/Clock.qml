import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.services
import qs.config
import qs.widgets

BarModule {
    id: clockContainer

    property string format: isVertical ? "hh\nmm" : "hh:mm • dd/MM"
    property bool isVertical: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right")

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // Let the layout compute size automatically

    Rectangle {
        id: bgRect

        color: isVertical ? "transparent" : Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        // Padding around the text
        implicitWidth: isVertical ? textItem.implicitWidth + 40 : textItem.implicitWidth + Appearance.margin.large
        implicitHeight: isVertical ? textItem.implicitHeight - 10 : textItem.implicitHeight + Appearance.margin.small
    }

    StyledText {
        id: textItem
        anchors.centerIn: parent
        animate: false
        text: Time.format(clockContainer.format)
    }

}
