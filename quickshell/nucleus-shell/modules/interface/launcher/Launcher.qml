import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import qs.modules.components
import qs.modules.functions
import qs.config
import qs.services

PanelWindow {
    id: launcherWindow

    readonly property bool launcherOpen: Globals.visiblility.launcher
    readonly property bool gridLayout: Config.runtime.launcher.layout === "grid"
    readonly property bool listLayout: Config.runtime.launcher.layout === "list"

    property int launcherHeight: listLayout ? DisplayMetrics.scaledHeight(0.63) : DisplayMetrics.scaledHeight(0.43)
    property int launcherWidth: listLayout ? DisplayMetrics.scaledHeight(0.5) : DisplayMetrics.scaledHeight(0.56)

    visible: launcherOpen
    focusable: true
    aboveWindows: true
    WlrLayershell.keyboardFocus: Globals.visiblility.launcher
    WlrLayershell.namespace: "nucleus:launcher"
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore

    Connections {
        target: launcherWindow
        function onLauncherOpenChanged() {
            if (!launcherWindow.launcherOpen) {
                launcherContent.currentSearch = ""
                launcherContent.entryIndex = 0
                launcherContent.appList = Apps.list
                searchField.text = ""
            }
        }
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        MouseArea {
            anchors.fill: parent
            onClicked: Globals.visiblility.launcher = false
        }
    }

    mask: Region {
        item: overlay
        intersection: Globals.visiblility.launcher ? Intersection.Combine : Intersection.Xor
    }

    StyledRect {
        id: launcherContent
        anchors.centerIn: parent
        radius: Metrics.radius(10)
        implicitHeight: launcherHeight
        implicitWidth: launcherWidth
        color: Appearance.m3colors.m3background
        clip: true

        property string currentSearch: ""
        property int entryIndex: 0
        property list<DesktopEntry> appList: Apps.list

        Behavior on implicitHeight {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
        Behavior on implicitWidth {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }

        RowLayout {
            id: headerRow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 8
            z: 12

            StyledRect {
                anchors.fill: parent
                color: Appearance.m3colors.m3background
                radius: launcherContent.radius
                z: 11
            }

            StyledTextField {
                id: searchField
                clip: true
                horizontalAlignment: Text.AlignLeft
                placeholderText: "Search an app or action..."
                Layout.fillWidth: true
                Layout.topMargin: Metrics.margin(10)
                Layout.bottomMargin: Metrics.margin(10)
                Layout.leftMargin: Metrics.margin(5)
                icon: "search"
                filled: false
                focus: true
                radius: Metrics.margin(14)
                z: 13
                font.pixelSize: Metrics.fontSize(14)

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        if (launcherContent.appList.length > 0) {
                            launcherContent.appList[launcherContent.entryIndex].execute()
                            Globals.visiblility.launcher = false
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Escape) {
                        Globals.visiblility.launcher = false
                        event.accepted = true
                    } else if (event.key === Qt.Key_Down) {
                        if (launcherContent.entryIndex < launcherContent.appList.length - 1)
                            launcherContent.entryIndex += 1
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        if (launcherContent.entryIndex > 0)
                            launcherContent.entryIndex -= 1
                        event.accepted = true
                    } else if (event.key === Qt.Key_Right && launcherWindow.gridLayout) {
                        if (launcherContent.entryIndex < launcherContent.appList.length - 1)
                            launcherContent.entryIndex += 1
                        event.accepted = true
                    } else if (event.key === Qt.Key_Left && launcherWindow.gridLayout) {
                        if (launcherContent.entryIndex > 0)
                            launcherContent.entryIndex -= 1
                        event.accepted = true
                    }
                }

                onTextChanged: {
                    launcherContent.currentSearch = text
                    launcherContent.appList = Apps.fuzzyQuery(launcherContent.currentSearch)
                    launcherContent.entryIndex = 0
                }
            }

            StyledRect {
                color: Appearance.m3colors.m3surfaceContainerHigh
                radius: Metrics.radius(18)
                width: 105
                height: searchField.height
                Layout.rightMargin: Metrics.margin(5)
                z: 13

                StyledRect {
                    id: indicator
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    radius: Metrics.radius(14)
                    color: Appearance.m3colors.m3primaryContainer
                    property Item activeButton: gridLayout ? gridButton : listButton
                    x: (activeButton ? activeButton.x + activeButton.width / 2 - width / 2 : 0) + 16

                    Behavior on x {
                        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 16

                    MaterialSymbol {
                        id: gridButton
                        icon: "view_cozy"
                        iconSize: 28
                        fill: 1
                        color: gridLayout ? Appearance.m3colors.m3surface : Appearance.syntaxHighlightingTheme
                        MouseArea {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            onClicked: Config.updateKey("launcher.layout", "grid")
                        }
                    }

                    MaterialSymbol {
                        id: listButton
                        icon: "view_list"
                        iconSize: 28
                        fill: 1
                        color: !gridLayout ? Appearance.m3colors.m3surface : Appearance.syntaxHighlightingTheme
                        MouseArea {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            onClicked: Config.updateKey("launcher.layout", "list")
                        }
                    }
                }
            }
        }

        // Each view gets its own ScrollView so visibility toggling works correctly
        ScrollView {
            anchors.top: headerRow.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Metrics.margin(10)
            clip: true
            visible: launcherWindow.listLayout

            ListView {
                id: appList
                anchors.fill: parent
                anchors.bottomMargin: Metrics.margin(4)
                spacing: Metrics.spacing(10)
                model: launcherContent.appList
                currentIndex: launcherContent.entryIndex
                delegate: AppItem {
                    required property int index
                    required property DesktopEntry modelData
                    selected: index === launcherContent.entryIndex
                    parentWidth: appList.width
                }
            }
        }

        ScrollView {
            anchors.top: headerRow.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.margins: Metrics.margin(10)
            clip: true
            visible: launcherWindow.gridLayout

            GridView {
                id: appGrid
                anchors.fill: parent
                cellWidth: Math.floor(width / 5)
                cellHeight: cellWidth
                model: launcherContent.appList
                currentIndex: launcherContent.entryIndex
                delegate: AppItem {
                    required property int index
                    required property DesktopEntry modelData
                    selected: index === launcherContent.entryIndex
                    parentWidth: appGrid.width
                }
            }
        }
    }

    IpcHandler {
        function toggle() {
            Globals.visiblility.launcher = !Globals.visiblility.launcher
        }
        target: "launcher"
    }
}