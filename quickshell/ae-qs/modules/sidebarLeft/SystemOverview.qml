import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.functions
import qs.services
import qs.settings
import qs.widgets

Item {
    id: root

    property string ramUsage: "—"
    property real ramPercent: 0
    property string cpuLoad: "—"
    property real cpuPercent: 0
    property string diskUsage: "—"
    property real diskPercent: 0

    implicitWidth: 300
    implicitHeight: parent ? parent.height : 500

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            ramProc.running = true;
            cpuProc.running = true;
            diskProc.running = true;
        }
    }

    // -------------------------
    // RAM
    // -------------------------
    Process {
        id: ramProc

        running: true
        command: ["free", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.split("\n").find((l) => {
                    return l.startsWith("Mem:");
                });
                if (!line)
                    return ;

                const p = line.split(/\s+/);
                const total = parseInt(p[1]);
                const used = parseInt(p[2]);
                ramPercent = used / total;
                ramUsage = `${used}/${total} MB`;
            }
        }

    }

    // -------------------------
    // CPU
    // -------------------------
    Process {
        id: cpuProc

        running: true
        command: ["uptime"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/load average: ([0-9.]+)/);
                if (!match)
                    return ;

                const load = parseFloat(match[1]);
                cpuPercent = Math.min(load / 4, 1);
                cpuLoad = load.toFixed(2);
            }
        }

    }

    // -------------------------
    // DISK
    // -------------------------
    Process {
        id: diskProc

        running: true
        command: ["df", "-h", "/"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length < 2)
                    return ;

                const p = lines[1].split(/\s+/);
                const used = p[2];
                const total = p[1];
                const percent = parseInt(p[4]) / 100;
                diskPercent = percent;
                diskUsage = `${used}/${total}`;
            }
        }

    }

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
                    text: `ae-qs ${Shell.flags.shellInfo.version}`
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
                            text: cpuLoad
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * cpuPercent
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
                            text: "RAM Usage"
                            color: Appearance.colors.colSubtext
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StyledText {
                            text: ramUsage
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * ramPercent
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
                            text: diskUsage
                            color: Appearance.colors.colSubtext
                        }

                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 10
                        radius: 5
                        color: Appearance.colors.colLayer1

                        Rectangle {
                            width: parent.width * diskPercent
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
            visible: SystemDetails.hasBattery

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
                        text: `${Math.round(SystemDetails.batteryPercent)}%`
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
                        text: SystemDetails.onAC ? "online" : "battery"
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
