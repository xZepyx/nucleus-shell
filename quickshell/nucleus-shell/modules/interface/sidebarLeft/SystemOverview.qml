import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules.functions
import qs.services
import qs.config
import qs.modules.widgets

Item {
    id: root

    implicitWidth: 300
    implicitHeight: parent ? parent.height : 500

    ColumnLayout {
        anchors.topMargin: 90
        anchors.fill: parent
        anchors.margins: Appearance.margin.normal
        spacing: Appearance.margin.small

        // Header
        RowLayout {
            Layout.fillWidth: true

            RowLayout {
                spacing: Appearance.margin.normal

                StyledText {
                    text: SystemDetails.osIcon
                    font.family: Appearance.font.family.nerdIcons
                    font.pixelSize: 48
                    color: Appearance.colors.colPrimary
                }

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: SystemDetails.osName
                        font.pixelSize: Appearance.font.size.large
                        color: Appearance.m3colors.m3onSurface
                    }

                    StyledText {
                        text: `${SystemDetails.username}@${SystemDetails.hostname}`
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.colors.colSubtext
                    }

                }

            }

            Item {
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: 2
                Layout.alignment: Qt.AlignRight

                StyledText {
                    text: `qs ${SystemDetails.qsVersion}`
                    font.pixelSize: Appearance.font.size.small
                    color: Appearance.colors.colSubtext
                }

                StyledText {
                    text: `nucleus-shell v${Config.runtime.shell.version}`
                    font.pixelSize: Appearance.font.size.smaller
                    color: Appearance.colors.colSubtext
                }

            }

        }

        // Uptime
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 56
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small

                StyledText {
                    text: "Uptime"
                    font.pixelSize: Appearance.font.size.normal
                    color: Appearance.colors.colPrimary
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: SystemDetails.uptime
                    font.pixelSize: Appearance.font.size.small
                    color: Appearance.m3colors.m3onSurface
                }

            }

        }

        // OS
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 56
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small

                StyledText {
                    text: "Operating System"
                    font.pixelSize: Appearance.font.size.normal
                    color: Appearance.colors.colPrimary
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: SystemDetails.osName
                    font.pixelSize: Appearance.font.size.small
                    color: Appearance.m3colors.m3onSurface
                    elide: Text.ElideRight
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 320
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.large
                spacing: Appearance.margin.normal

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        StyledText {
                            text: "CPU Usage"
                            color: Appearance.colors.colSubtext
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StyledText {
                            animate: false
                            text: SystemDetails.cpuLoad
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * SystemDetails.cpuPercent
                            height: parent.height
                            radius: 5
                            color: Appearance.colors.colPrimary
                        }

                    }

                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        StyledText {
                            text: "Ram Usage"
                            color: Appearance.colors.colSubtext
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StyledText {
                            animate: false
                            text: SystemDetails.ramUsage
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * SystemDetails.ramPercent
                            height: parent.height
                            radius: 5
                            color: Appearance.colors.colPrimary
                        }

                    }

                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        StyledText {
                            text: "Disk Usage"
                            color: Appearance.colors.colSubtext
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StyledText {
                            animate: false
                            text: SystemDetails.diskUsage
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * SystemDetails.diskPercent
                            height: parent.height
                            radius: 5
                            color: Appearance.colors.colPrimary
                        }

                    }

                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        StyledText {
                            text: "Swap Usage"
                            color: Appearance.colors.colSubtext
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StyledText {
                            text: SystemDetails.swapUsage
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * SystemDetails.swapPercent
                            height: parent.height
                            radius: 5
                            color: Appearance.colors.colPrimary
                        }

                    }

                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 72
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small
                spacing: Appearance.margin.large

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: "Kernel"
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.colors.colSubtext
                    }

                    StyledText {
                        text: SystemDetails.kernelVersion
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.m3colors.m3onSurface
                    }

                }

                Item {
                    Layout.fillWidth: true
                }

                ColumnLayout {
                    spacing: 2
                    Layout.alignment: Qt.AlignRight

                    StyledText {
                        text: "Architecture"
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.colors.colSubtext
                        horizontalAlignment: Text.AlignRight
                    }

                    StyledText {
                        text: SystemDetails.architecture
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.m3colors.m3onSurface
                        horizontalAlignment: Text.AlignRight
                    }

                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 72
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2
            visible: UPower.batteryPresent

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small
                spacing: Appearance.margin.large

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: "Battery"
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.colors.colSubtext
                    }

                    StyledText {
                        text: `${Math.round(UPower.percentage)}%`
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.m3colors.m3onSurface
                    }

                }

                Item {
                    Layout.fillWidth: true
                }

                ColumnLayout {
                    spacing: 2
                    Layout.alignment: Qt.AlignRight

                    StyledText {
                        text: "AC"
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.colors.colSubtext
                        horizontalAlignment: Text.AlignRight
                    }

                    StyledText {
                        text: UPower.acOnline ? "online" : "battery"
                        font.pixelSize: Appearance.font.size.small
                        color: Appearance.m3colors.m3onSurface
                        horizontalAlignment: Text.AlignRight
                    }

                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 56
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small

                StyledText {
                    text: "Running Processes"
                    font.pixelSize: Appearance.font.size.normal
                    color: Appearance.colors.colPrimary
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: SystemDetails.runningProcesses
                    font.pixelSize: Appearance.font.size.small
                    color: Appearance.m3colors.m3onSurface
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 56
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer2

            RowLayout {
                anchors.fill: parent
                anchors.margins: Appearance.margin.small

                StyledText {
                    text: "Logged-in Users"
                    font.pixelSize: Appearance.font.size.normal
                    color: Appearance.colors.colPrimary
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: SystemDetails.loggedInUsers
                    font.pixelSize: Appearance.font.size.small
                    color: Appearance.m3colors.m3onSurface
                }

            }

        }

        Item {
            Layout.fillHeight: true
        }

    }

}