import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.modules.functions
import qs.services

Item {
    id: root

    implicitWidth: clockColumn.implicitWidth
    implicitHeight: clockColumn.implicitHeight

    property bool use12Hour: Config.runtime.appearance.background.clock.use12Hour
    property bool twoLine: Config.runtime.appearance.background.clock.vertical

    property int hour24: parseInt(Time.format("HH"))
    property int hourDisplay: use12Hour
        ? ((hour24 % 12) === 0 ? 12 : hour24 % 12)
        : hour24

    property string hourString: hourDisplay.toString().padStart(2, "0")

    property int minuteValue: parseInt(Time.format("mm"))
    property string minuteString: minuteValue.toString().padStart(2, "0")



    ColumnLayout {
        id: clockColumn
        anchors.centerIn: parent
        spacing: Metrics.spacing(8)

        Loader {
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: twoLine ? expressiveClock : classicClock
        }

        StyledText {
            text: Time.format("dddd, dd MMM")

            font.pixelSize: Metrics.fontSize(24)
            font.family: Appearance.font.families.expressive
            font.weight: Font.DemiBold
            font.letterSpacing: 1
            renderType: Text.NativeRendering

            color: Qt.rgba(
                Appearance.m3colors.m3onSurfaceVariant.r,
                Appearance.m3colors.m3onSurfaceVariant.g,
                Appearance.m3colors.m3onSurfaceVariant.b,
                0.65
            )

            Layout.alignment: Qt.AlignHCenter
        }
    }



    Component {
        id: classicClock

        RowLayout {
            spacing: Metrics.spacing(6)

            Item {
                width: Metrics.fontSize(92) * 1.2
                height: Metrics.fontSize(92)

                AnimatedDigit {
                    anchors.centerIn: parent
                    value: root.hourString
                    size: Metrics.fontSize(92)
                }
            }

            StyledText {
                id: colon
                text: ":"

                font.pixelSize: Metrics.fontSize(92)
                font.family: Appearance.font.families.expressive
                font.weight: Font.Medium
                font.letterSpacing: 1
                renderType: Text.NativeRendering

                color: Appearance.m3colors.m3primary
                opacity: 1
            }

            Item {
                width: Metrics.fontSize(92) * 1.2
                height: Metrics.fontSize(92)

                AnimatedDigit {
                    anchors.centerIn: parent
                    value: root.minuteString
                    size: Metrics.fontSize(92)
                }
            }

            StyledText {
                visible: use12Hour
                text: Time.format("AP")

                font.pixelSize: Metrics.fontSize(20)
                font.family: Appearance.font.families.expressive
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering

                color: Appearance.m3colors.m3onSurfaceVariant
                Layout.alignment: Qt.AlignBottom
            }

            Timer {
                interval: 900
                running: true
                repeat: true
                onTriggered: colon.opacity = colon.opacity === 1 ? 0 : 1
            }
        }
    }



    Component {
        id: expressiveClock

        ColumnLayout {
            spacing: Metrics.spacing(-12)

            Item {
                width: Metrics.fontSize(110) * 1.2
                height: Metrics.fontSize(110)

                AnimatedDigit {
                    anchors.centerIn: parent
                    value: root.hourString
                    size: Metrics.fontSize(110)
                }
            }

            Item {
                width: Metrics.fontSize(110) * 1.2
                height: Metrics.fontSize(110)

                AnimatedDigit {
                    anchors.centerIn: parent
                    value: root.minuteString
                    size: Metrics.fontSize(110)
                }
            }
        }
    }
}