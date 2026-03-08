import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.services

Item {
    id: systemUsageContainer
    property string displayName: screen?.name ?? ""
    property bool isHorizontal: (ConfigResolver.bar(displayName).position === "top" || ConfigResolver.bar(displayName).position === "bottom")

    visible: ConfigResolver.bar(displayName).modules.systemUsage.enabled && haveWidth
    Layout.alignment: Qt.AlignVCenter

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    property bool haveWidth:
        ConfigResolver.bar(displayName).modules.systemUsage.tempStatsEnabled ||
        ConfigResolver.bar(displayName).modules.systemUsage.cpuStatsEnabled ||
        ConfigResolver.bar(displayName).modules.systemUsage.memoryStatsEnabled


    // Normalize values so UI always receives correct ranges
    function normalize(v) {
        if (v > 1) return v / 100
        return v
    }

    function percent(v) {
        if (v <= 1) return Math.round(v * 100)
        return Math.round(v)
    }

    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: ConfigResolver.bar(displayName).modules.radius * Config.runtime.appearance.rounding.factor

        implicitWidth: child.implicitWidth + Metrics.margin("large")
        implicitHeight: ConfigResolver.bar(displayName).modules.height
    }

    RowLayout {
        id: child
        anchors.centerIn: parent
        spacing: Metrics.spacing(4)

        // CPU
        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            icon: "developer_board"
            visible: ConfigResolver.bar(displayName).modules.systemUsage.cpuStatsEnabled
            iconSize: Metrics.iconSize(14)
            value: normalize(SystemDetails.cpuPercent)
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: ConfigResolver.bar(displayName).modules.systemUsage.cpuStatsEnabled && isHorizontal
            animate: false
            text: percent(SystemDetails.cpuPercent) + "%"
        }

        // RAM
        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            Layout.leftMargin: Metrics.margin(4)
            icon: "memory_alt"
            visible: ConfigResolver.bar(displayName).modules.systemUsage.memoryStatsEnabled
            iconSize: Metrics.iconSize(14)
            value: normalize(SystemDetails.ramPercent)
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: ConfigResolver.bar(displayName).modules.systemUsage.memoryStatsEnabled && isHorizontal
            animate: false
            text: percent(SystemDetails.ramPercent) + "%"
        }

        // Temperature
        CircularProgressBar {
            rotation: !isHorizontal ? 270 : 0
            visible: ConfigResolver.bar(displayName).modules.systemUsage.tempStatsEnabled
            Layout.leftMargin: Metrics.margin(4)
            icon: "device_thermostat"
            iconSize: Metrics.iconSize(14)
            value: normalize(SystemDetails.cpuTempPercent)
            Layout.bottomMargin: Metrics.margin(2)
        }

        StyledText {
            visible: ConfigResolver.bar(displayName).modules.systemUsage.tempStatsEnabled && isHorizontal
            animate: false
            text: percent(SystemDetails.cpuTempPercent) + "%"
        }
    }
}
