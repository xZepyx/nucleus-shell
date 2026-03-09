import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.components

Item {
    id: clockContainer

    property string displayName: screen?.name ?? ""

    property bool isVertical:
        ConfigResolver.bar(displayName).position === "left"
        || ConfigResolver.bar(displayName).position === "right"

    property bool blink: true

    Layout.alignment: Qt.AlignVCenter

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight


    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: blink = !blink
    }


    Rectangle {
        id: background

        anchors.fill: parent

        implicitWidth: isVertical
            ? verticalClock.implicitWidth + 12
            : horizontalClock.implicitWidth + Metrics.margin("large")

        implicitHeight: ConfigResolver.bar(displayName).modules.height

        radius: ConfigResolver.bar(displayName).modules.radius
                * Config.runtime.appearance.rounding.factor

        color: isVertical
            ? "transparent"
            : Appearance.m3colors.m3surfaceContainerLow
    }


    RowLayout {
        id: horizontalClock

        visible: !isVertical
        anchors.centerIn: parent
        spacing: 2

        StyledText {
            text: Time.format("hh")
            font.pixelSize: Appearance.font.size.small
        }

        StyledText {
            id: colon
            text: ":"

            font.pixelSize: Appearance.font.size.small

            opacity: clockContainer.blink ? 1 : 0

            Layout.preferredWidth: implicitWidth

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }

        StyledText {
            text: Time.format("mm")
            font.pixelSize: Appearance.font.size.small
        }

        StyledText {
            text: " • " + Time.format("dd MMM")
            font.pixelSize: Appearance.font.size.small
            opacity: 0.75
        }
    }


    ColumnLayout {
        id: verticalClock

        visible: isVertical
        anchors.centerIn: parent
        spacing: 0

        StyledText {
            text: Time.format("hh")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.size.small
        }

        StyledText {
            text: Time.format("mm")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.size.small
        }

        StyledText {
            text: Time.format("AP")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.size.small * 0.8
            opacity: 0.7
        }
    }
}
