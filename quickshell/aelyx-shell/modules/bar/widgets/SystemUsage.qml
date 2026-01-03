import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.services
import qs.config
import qs.widgets

BarModule {
    id: clockContainer

    Layout.alignment: Qt.AlignVCenter
    // Let the layout compute size automatically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        // Padding around the text
        implicitWidth: child.implicitWidth + Appearance.margin.large
        implicitHeight: child.implicitHeight + Appearance.margin.verysmall - 2
    }

    RowLayout {
        id: child

        anchors.centerIn: parent
        spacing: 4

        CircularProgressBar {
            icon: "memory"
            iconSize: 13
            value: SystemDetails.cpuPercent
            Layout.bottomMargin: 2
        }
        
        StyledText {
            animate: false
            text: Math.round(SystemDetails.cpuPercent * 100) + "%"
        }

        CircularProgressBar {
            Layout.leftMargin: 4
            icon: "memory_alt"
            iconSize: 13
            value: SystemDetails.ramPercent
            Layout.bottomMargin: 2
        }
        
        StyledText {
            animate: false
            text: Math.round(SystemDetails.ramPercent * 100) + "%"
        }

        CircularProgressBar {
            Layout.leftMargin: 4
            icon: "device_thermostat"
            iconSize: 13
            value: SystemDetails.cpuTempPercent
            Layout.bottomMargin: 2
        }
        
        StyledText {
            animate: false
            text: Math.round(SystemDetails.cpuTempPercent * 100) + "%"
        }

    }

}
