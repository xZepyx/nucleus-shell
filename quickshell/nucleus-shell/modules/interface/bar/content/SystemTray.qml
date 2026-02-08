import qs.modules.components
import qs.config
import Quickshell.Services.SystemTray
import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts

Item {
    id: root
    readonly property Repeater items: items

    clip: true
    implicitWidth: padding.width
    implicitHeight: padding.height

    Rectangle {
        visible: (items.count > 0) ? 1 : 0
        id: padding
        width: layout.width + Appearance.margin.verylarge
        height: 34
        anchors.fill: parent
        radius: Config.runtime.bar.modules.radius
        color: "transparent"
    }

    GridLayout {
        id: layout
        anchors.centerIn: parent
        rows: root.verticalMode ? 1 : 4
        columns: root.verticalMode ? 1 : 4
        rowSpacing: 10
        columnSpacing: 10

        Repeater {
            id: items
            model: SystemTray.items

            delegate: Item {
                id: trayItemRoot
                required property SystemTrayItem modelData
                implicitWidth: 20
                implicitHeight: 20

                IconImage {
                    visible: trayItemRoot.modelData.icon !== ""
                    source: trayItemRoot.modelData.icon
                    asynchronous: true
                    anchors.fill: parent
                }

                HoverHandler {
                    id: hover
                }

                QsMenuOpener {
                    id: menuOpener
                    menu: trayItemRoot.modelData.menu
                }

                StyledPopout {
                    id: popout
                    hoverTarget: hover
                    interactable: true
                    hCenterOnItem: true
                    requiresHover: false

                    Component {
                        Item {
                            width: childColumn.implicitWidth
                            height: childColumn.height

                            ColumnLayout {
                                id: childColumn
                                spacing: 5

                                Repeater {
                                    model: menuOpener.children
                                    delegate: TrayMenuItem {
                                        parentColumn: childColumn
                                        Layout.preferredWidth: childColumn.width > 0 ? childColumn.width : implicitWidth
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    hoverEnabled: true

                    onClicked: {
                        if (popout.isVisible)
                            popout.hide();
                        else
                            popout.show();
                    }
                }
            }
        }
    }

    component TrayMenuItem: Item {
        id: itemRoot
        required property QsMenuEntry modelData
        required property ColumnLayout parentColumn

        Layout.fillWidth: true
        implicitWidth: rowLayout.implicitWidth + 10
        implicitHeight: !itemRoot.modelData.isSeparator ? rowLayout.implicitHeight + 10 : 1

        MouseArea {
            id: hover
            hoverEnabled: itemRoot.modelData.enabled
            anchors.fill: parent
            onClicked: {
                if (!itemRoot.modelData.hasChildren)
                    itemRoot.modelData.triggered();
            }
        }

        Rectangle {
            id: itemBg
            anchors.fill: parent
            opacity: itemRoot.modelData.isSeparator ? 0.5 : 1
            color: itemRoot.modelData.isSeparator ? Appearance.m3colors.m3outline : hover.containsMouse ? Appearance.m3colors.m3surfaceContainer : Appearance.m3colors.m3surface
        }

        RowLayout {
            id: rowLayout
            visible: !itemRoot.modelData.isSeparator
            opacity: itemRoot.modelData.isSeparator ? 0.5 : 1
            spacing: 5
            anchors {
                left: itemBg.left
                leftMargin: 5
                top: itemBg.top
                topMargin: 5
            }

            IconImage {
                visible: itemRoot.modelData.icon !== ""
                source: itemRoot.modelData.icon
                width: 15
                height: 15
            }

            StyledText {
                text: itemRoot.modelData.text
                font.pixelSize: 14
                color: Appearance.m3colors.m3onSurface
            }

            MaterialSymbol {
                visible: itemRoot.modelData.hasChildren
                icon: "chevron_right"
                iconSize: 16
                color: Appearance.m3colors.m3onSurface
            }
        }
    }
}