import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.services

Item {
    id: batteryIndicatorModuleContainer

    visible: UPower.batteryPresent
    Layout.alignment: Qt.AlignVCenter

    // Determine if bar is isVertical
    property bool isVertical: ConfigResolver.bar(screen?.name ?? "").position === "left" || ConfigResolver.bar(screen?.name ?? "").position === "right"

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect
        color: isVertical ? Appearance.m3colors.m3primary : Appearance.m3colors.m3paddingContainer
        radius: ConfigResolver.bar(screen?.name ?? "").modules.radius * Config.runtime.appearance.rounding.factor // No need to use metrics here...

        implicitWidth: child.implicitWidth + Appearance.margin.large - (isVertical ? 10 : 0)
        implicitHeight: ConfigResolver.bar(screen?.name ?? "").modules.height
    }

    RowLayout {
        id: child
        anchors.centerIn: parent
        spacing: isVertical ? 0 : Metrics.spacing(8)

        // Icon for isVertical bars
        MaterialSymbol {
            visible: isVertical
            icon: UPower.battIcon
            iconSize: Metrics.iconSize(20)
        }

        // Battery percentage text
        StyledText {
            animate: false
            font.pixelSize: Metrics.fontSize(16)
            rotation: isVertical ? 270 : 0
            text: (isVertical ? UPower.percentage : UPower.percentage + "%")
        }

        // Circular progress for horizontal bars
        CircularProgressBar {
            visible: !isVertical
            value: UPower.percentage / 100
            icon: UPower.battIcon
            iconSize: Metrics.iconSize(18)
            Layout.bottomMargin: Metrics.margin(2)
        }
    }
}
