import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import qs.widgets
import qs.settings
import Quickshell

Item {
    id: root
    anchors.fill: parent

    /* ------------------------------
       Pomodoro state
    ------------------------------ */
    property int workDuration: 25 * 60
    property int breakDuration: 5 * 60
    property int remaining: workDuration
    property bool running: false
    property bool onBreak: false

    Timer {
        interval: 1000
        repeat: true
        running: root.running
        onTriggered: {
            if (remaining > 0) {
                remaining--
            } else {
                onBreak = !onBreak
                remaining = onBreak ? breakDuration : workDuration
            }
        }
    }

    function formatTime(sec) {
        const m = Math.floor(sec / 60)
        const s = sec % 60
        return m + ":" + (s < 10 ? "0" + s : s)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Appearance.margin.large

        /* Pomodoro */
        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            radius: Appearance.rounding.normal
            color: Appearance.m3colors.m3surfaceContainer

            Column {
                anchors.centerIn: parent
                spacing: 8

                StyledText {
                    text: onBreak ? "Break" : "Focus"
                    font.pixelSize: Appearance.font.size.large
                }

                StyledText {
                    text: formatTime(remaining)
                    font.pixelSize: Appearance.font.size.huge
                    font.weight: Font.Bold
                }

                Row {
                    spacing: 12
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: running ? "Pause" : "Start"
                        onClicked: running = !running
                    }

                    Button {
                        text: "Reset"
                        onClicked: {
                            running = false
                            onBreak = false
                            remaining = workDuration
                        }
                    }
                }
            }
        }

        /* Kanban */
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Appearance.margin.normal

            KanbanColumn { title: "Todo" }
            KanbanColumn { title: "Doing" }
            KanbanColumn { title: "Done" }
        }
    }

    /* ==============================
       INLINE COMPONENT (VALID)
    ============================== */
    component KanbanColumn: StyledRect {
        required property string title

        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: Appearance.rounding.normal
        color: Appearance.m3colors.m3surfaceContainer

        ListModel { id: taskModel }

        ColumnLayout {
            anchors.fill: parent
            spacing: Appearance.margin.small

            StyledText {
                text: title
                font.pixelSize: Appearance.font.size.large
                font.weight: Font.Medium
                Layout.alignment: Qt.AlignHCenter
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: taskModel
                spacing: 8
                clip: true

                delegate: StyledRect {
                    width: ListView.view.width
                    height: 44
                    radius: Appearance.rounding.small
                    color: Appearance.m3colors.m3surfaceContainerLow

                    StyledText {
                        anchors.centerIn: parent
                        text: model.text
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: taskModel.remove(index)
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

            TextField {
                Layout.fillWidth: true
                placeholderText: "Add task…"
                onAccepted: {
                    if (!text.length) return
                    taskModel.append({ text })
                    text = ""
                }
            }
        }
    }
}
