import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.services

Item {
    id: systemUsageContainer
    property bool isHorizontal: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom")
    visible: Config.runtime.bar.modules.systemUsage.enabled && haveWidth
    Layout.alignment: Qt.AlignVCenter
    // Let the layout compute size automatically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight


    // bool to show the prevent a small empty block showing up in the bar if all of the stats are disabled
    property bool haveWidth: Config.runtime.bar.modules.systemUsage.tempStatsEnabled || Config.runtime.bar.modules.systemUsage.cpuStatsEnabled || Config.runtime.bar.modules.systemUsage.memoryStatsEnabled

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        // Padding around the text
        implicitWidth: child.implicitWidth + Metrics.margin("large")
        implicitHeight: Config.runtime.bar.modules.height
    }

    RowLayout {
        id: child

        anchors.centerIn: parent
        spacing: Metrics.spacing(4)

        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            icon: "memory"
            visible: Config.runtime.bar.modules.systemUsage.cpuStatsEnabled
            iconSize: Metrics.iconSize(14)
            value: SystemDetails.cpuPercent
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: Config.runtime.bar.modules.systemUsage.cpuStatsEnabled && isHorizontal
            animate: false
            text: Math.round(SystemDetails.cpuPercent * 100) + "%"
        }

        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            Layout.leftMargin: Metrics.margin(4)
            icon: "memory_alt"
            visible: Config.runtime.bar.modules.systemUsage.memoryStatsEnabled
            iconSize: Metrics.iconSize(14)
            value: SystemDetails.ramPercent
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: Config.runtime.bar.modules.systemUsage.memoryStatsEnabled && isHorizontal
            animate: false
            text: Math.round(SystemDetails.ramPercent * 100) + "%"
        }

        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            visible: Config.runtime.bar.modules.systemUsage.tempStatsEnabled
            Layout.leftMargin: Metrics.margin(4)
            icon: "device_thermostat"
            iconSize: Metrics.iconSize(14)
            value: SystemDetails.cpuTempPercent
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: Config.runtime.bar.modules.systemUsage.tempStatsEnabled && isHorizontal
            animate: false
            text: Math.round(SystemDetails.cpuTempPercent * 100) + "%"
        }

    }

}
