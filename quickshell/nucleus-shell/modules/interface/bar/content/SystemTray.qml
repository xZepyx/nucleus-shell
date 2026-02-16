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
    property bool horizontalMode: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom")
    clip: true
    implicitWidth: layout.implicitWidth + Metrics.margin("verylarge")
    implicitHeight: 34

    Rectangle {
        visible: (items.count > 0) ? 1 : 0
        id: padding
        implicitHeight: padding.height
        anchors.fill: parent
        radius: Config.runtime.bar.modules.radius
        color: "transparent"
    }

    GridLayout {
        id: layout
        anchors.centerIn: parent
        rows: 1
        columns: items.count
        rowSpacing: Metrics.spacing(10)
        columnSpacing: Metrics.spacing(10)

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
                    rotation: root.horizontalMode ? 0 : 270
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
                                spacing: Metrics.spacing(5)

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
            spacing: Metrics.spacing(5)
            anchors {
                left: itemBg.left
                leftMargin: Metrics.margin(5)
                top: itemBg.top
                topMargin:Metrics.margin(5)
            }

            IconImage {
                visible: itemRoot.modelData.icon !== ""
                source: itemRoot.modelData.icon
                width: 15
                height: 15
            }

            StyledText {
                text: itemRoot.modelData.text
                font.pixelSize: Metrics.fontSize(14)
                color: Appearance.m3colors.m3onSurface
            }

            MaterialSymbol {
                visible: itemRoot.modelData.hasChildren
                icon: "chevron_right"
                iconSize: Metrics.iconSize(16)
                color: Appearance.m3colors.m3onSurface
            }
        }
    }
}