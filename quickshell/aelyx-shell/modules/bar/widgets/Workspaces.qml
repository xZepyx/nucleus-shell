import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.services
import qs.config
import qs.widgets

BarModule {
    id: workspaceContainer

    property int numWorkspaces: Shell.flags.bar.modules.workspaces.workspaceIndicators

    function workspaceIcon(n) {
        const map = ["", "dvr", "terminal", "desktop_windows", "browse", "design_services", "chat", "android", "avg_pace", "九", "十"];
        return map[n] ?? n.toString();
    }

    Layout.alignment: Qt.AlignVCenter
    Layout.leftMargin: 10
    Layout.rightMargin: 8
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large
        implicitHeight: workspaceRow.implicitHeight + Appearance.margin.normal - 4

        RowLayout {
            id: workspaceRow

            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: numWorkspaces

                Item {
                    property bool focused: (index + 1) === Hyprland.focusedWorkspaceId
                    property bool occupied: Hyprland.isWorkspaceOccupied(index + 1)

                    width: 22
                    height: 22

                    Rectangle {
                        id: bg

                        anchors.fill: parent
                        radius: 10
                        color: focused ? Appearance.m3colors.m3tertiary : "transparent"
                    }

                    MaterialSymbol {
                        id: symbol
                        animate: false
                        anchors.centerIn: parent
                        
                        text: (focused || occupied) ? workspaceIcon(index + 1) : "fiber_manual_record"
                        
                        font.variableAxes: { 
                            "FILL": (symbol.text === "fiber_manual_record") ? 1.0 : 0.0 
                        }

                        rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                        font.pixelSize: Appearance.font.size.large
                        color: focused ? Appearance.m3colors.m3shadow : Appearance.m3colors.m3secondary
                    }


                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }

                }

            }

        }

    }

}
