pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Wayland
import qs.config
import qs.services
import qs.modules.components

PanelWindow {
    id: launcher


    WlrLayershell.namespace:     "nucleus:launcher"
    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: Globals.visiblility.launcher

    color:    "transparent"
    visible:  Globals.visiblility.launcher

    anchors { top: true; bottom: true; left: true; right: true }


    property string searchText:   ""
    property int    categoryIndex: 0
    property bool   isSearching:  searchText.length > 0

    readonly property var allApps: Apps.list

    readonly property var displayApps: {
        if (isSearching)
            return Config.runtime.launcher.fuzzySearchEnabled
                ? Apps.fuzzyQuery(searchText)
                : allApps.filter(a =>
                    a.name.toLowerCase().includes(searchText.toLowerCase()))

        if (categoryIndex === 0)
            return allApps

        const cat = _categories[categoryIndex].key
        return allApps.filter(a =>
            (a.categories ?? []).some(c => c.toLowerCase().includes(cat)))
    }

    readonly property var _categories: [
        { label: "All",       icon: "apps",           key: "" },
        { label: "Internet",  icon: "language",        key: "network" },
        { label: "Media",     icon: "play_circle",     key: "audio" },
        { label: "Dev",       icon: "code",            key: "development" },
        { label: "System",    icon: "settings",        key: "system" },
        { label: "Games",     icon: "sports_esports",  key: "game" },
        { label: "Office",    icon: "work",            key: "office" },
        { label: "Graphics",  icon: "palette",         key: "graphics" },
    ]

    // Reset on close
    onVisibleChanged: {
        if (!visible) {
            searchText    = ""
            categoryIndex = 0
            searchField.text = ""
        } else {
            revealAnim.restart()
            Qt.callLater(() => searchField.forceActiveFocus())
        }
    }


    Rectangle {
        anchors.fill: parent
        color:   "#000000"
        opacity: launcher.visible ? 0.45 : 0
        z: 0
        Behavior on opacity {^\s*//\s*[-─=]{2,}.*
            NumberAnimation {
                duration: Appearance.animation.durations.normal
                easing.type: Easing.OutCubic
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Globals.visiblility.launcher = false
        }
    }


    Item {
        id: sheet
        z: 1
        width:  Math.min(parent.width  * 0.82, 880)
        height: Math.min(parent.height * 0.80, 700)
        anchors.centerIn: parent

        property real revealProgress: 0
        NumberAnimation on revealProgress {
            id: revealAnim
            from: 0; to: 1
            duration: Appearance.animation.durations.expressiveDefaultSpatial
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.curves.expressiveDefaultSpatial
        }

        opacity: revealProgress
        scale:   0.88 + 0.12 * revealProgress
        transformOrigin: Item.Center


        Rectangle {
            id: card
            anchors.fill: parent
            radius: Appearance.rounding.verylarge
            color:  Appearance.m3colors.m3background

            // Primary tint gradient
            /* Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(
                            Appearance.colors.colPrimary.r,
                            Appearance.colors.colPrimary.g,
                            Appearance.colors.colPrimary.b,
                            0.055)
                    }
                    GradientStop { position: 0.6; color: "transparent" }
                }
            } */

        }


        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Appearance.margin.large
            spacing: Appearance.margin.small


            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.margin.small

                Rectangle {
                    width: 40; height: 40
                    radius: Appearance.rounding.normal
                    color: Appearance.colors.colPrimary

                    MaterialSymbol {
                        anchors.centerIn: parent
                        icon: "apps"
                        iconSize: Metrics.iconSize(20)
                        color: Appearance.colors.colOnPrimary
                    }
                }

                StyledText {
                    text: "Applications"
                    font.family:    Appearance.font.family.title
                    font.pixelSize: Metrics.fontSize("large")
                    font.weight:    Font.DemiBold
                    opacity: 0.85
                }

                Item { Layout.fillWidth: true }

                // Result count badge (search only)
                Rectangle {
                    visible: launcher.isSearching
                    height: 26
                    width:  resultLabel.implicitWidth + 20
                    radius: Appearance.rounding.full
                    color: Qt.rgba(
                        Appearance.colors.colPrimary.r,
                        Appearance.colors.colPrimary.g,
                        Appearance.colors.colPrimary.b, 0.14)

                    StyledText {
                        id: resultLabel
                        anchors.centerIn: parent
                        text: launcher.displayApps.length + " results"
                        font.pixelSize: Metrics.fontSize("smaller")
                        color: Appearance.colors.colPrimary
                    }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // Close button
                Rectangle {
                    width: 34; height: 34
                    radius: Appearance.rounding.full
                    color: closeMa.containsMouse
                        ? Appearance.colors.colLayer2Hover : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }

                    MaterialSymbol {
                        anchors.centerIn: parent
                        icon: "close"
                        iconSize: Metrics.iconSize(20)
                        color: Appearance.colors.colOnLayer1
                        opacity: 0.7
                    }
                    MouseArea {
                        id: closeMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Globals.visiblility.launcher = false
                    }
                }
            }


            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: Appearance.rounding.verylarge
                color:  Appearance.colors.colLayer2
                border.color: searchField.activeFocus
                    ? Appearance.colors.colPrimary
                    : Appearance.colors.colOutline
                border.width: searchField.activeFocus ? 2 : 1

                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on border.width { NumberAnimation  { duration: 200 } }

                RowLayout {
                    anchors { fill: parent; leftMargin: 16; rightMargin: 12 }
                    spacing: 10

                    MaterialSymbol {
                        icon: "search"
                        iconSize: Metrics.iconSize(20)
                        color: searchField.activeFocus
                            ? Appearance.colors.colPrimary
                            : Appearance.colors.colSubtext
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    TextInput {
                        id: searchField
                        Layout.fillWidth: true
                        font.family:    Appearance.font.family.main
                        font.pixelSize: Metrics.fontSize("normal")
                        color:          Appearance.colors.colOnLayer2
                        selectionColor: Qt.rgba(
                            Appearance.colors.colPrimary.r,
                            Appearance.colors.colPrimary.g,
                            Appearance.colors.colPrimary.b, 0.3)
                        clip: true

                        onTextChanged: launcher.searchText = text

                        Keys.onEscapePressed: {
                            if (text.length > 0) { text = ""; return }
                            Globals.visiblility.launcher = false
                        }
                        Keys.onReturnPressed: {
                            if (launcher.displayApps.length > 0) {
                                Apps.launch(launcher.displayApps[0])
                                Globals.visiblility.launcher = false
                            }
                        }
                        Keys.onDownPressed: appGrid.forceActiveFocus()
                    }

                    // Clear button
                    Rectangle {
                        width: 28; height: 28
                        radius: Appearance.rounding.full
                        color:   clearMa.containsMouse
                            ? Appearance.colors.colLayer2Hover : "transparent"
                        visible: launcher.isSearching
                        opacity: visible ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        Behavior on color   { ColorAnimation  { duration: 120 } }

                        MaterialSymbol {
                            anchors.centerIn: parent
                            icon: "close"
                            iconSize: Metrics.iconSize(16)
                            color: Appearance.colors.colSubtext
                        }
                        MouseArea {
                            id: clearMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape:  Qt.PointingHandCursor
                            onClicked: searchField.text = ""
                        }
                    }
                }
            }


            Item {
                Layout.fillWidth: true
                height:  38
                visible: !launcher.isSearching
                opacity: visible ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                Row {
                    anchors.fill: parent
                    spacing: Appearance.margin.tiny

                    Repeater {
                        model: launcher._categories

                        delegate: Item {
                            required property int index
                            required property var modelData

                            width:  chipRect.implicitWidth
                            height: 38

                            Rectangle {
                                id: chipRect
                                height: 34
                                anchors.verticalCenter: parent.verticalCenter
                                implicitWidth: chipRow.implicitWidth + 22
                                radius: Appearance.rounding.full

                                readonly property bool selected: launcher.categoryIndex === index

                                color: selected
                                    ? Appearance.colors.colSecondaryContainer
                                    : chipMa.containsMouse
                                        ? Appearance.colors.colLayer2Hover
                                        : Appearance.colors.colLayer2

                                Behavior on color { ColorAnimation { duration: 160 } }

                                RowLayout {
                                    id: chipRow
                                    anchors.centerIn: parent
                                    spacing: 5

                                    MaterialSymbol {
                                        icon:      modelData.icon
                                        iconSize:  Metrics.iconSize(15)
                                        color:     chipRect.selected
                                            ? Appearance.colors.colOnSecondaryContainer
                                            : Appearance.colors.colOnLayer1
                                        Behavior on color { ColorAnimation { duration: 160 } }
                                    }

                                    StyledText {
                                        text:           modelData.label
                                        font.pixelSize: Metrics.fontSize("smaller")
                                        font.weight:    chipRect.selected ? Font.Medium : Font.Normal
                                        color:          chipRect.selected
                                            ? Appearance.colors.colOnSecondaryContainer
                                            : Appearance.colors.colOnLayer1
                                        Behavior on color { ColorAnimation { duration: 160 } }
                                    }
                                }

                                MouseArea {
                                    id: chipMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape:  Qt.PointingHandCursor
                                    onClicked: launcher.categoryIndex = index
                                }
                            }
                        }
                    }
                }
            }


            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Empty state
                Column {
                    anchors.centerIn: parent
                    spacing: Appearance.margin.small
                    visible: launcher.displayApps.length === 0
                    opacity: visible ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    MaterialSymbol {
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon: "search_off"
                        iconSize: Metrics.iconSize(52)
                        color: Appearance.colors.colSubtext
                        opacity: 0.5
                    }

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "No applications found"
                        font.pixelSize: Metrics.fontSize("normal")
                        color: Appearance.colors.colSubtext
                        opacity: 0.6
                    }
                }

                GridView {
                    id: appGrid
                    anchors.fill: parent
                    clip: true
                    focus: true

                    readonly property int cols: Math.max(3, Math.floor(width / 128))
                    cellWidth:  Math.floor(width / cols)
                    cellHeight: 118

                    model: launcher.displayApps

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            radius:  Appearance.rounding.full
                            color:   Appearance.colors.colOutline
                            opacity: 0.45
                        }
                    }

                    Keys.onReturnPressed: {
                        const idx = currentIndex
                        if (idx >= 0 && idx < launcher.displayApps.length) {
                            Apps.launch(launcher.displayApps[idx])
                            Globals.visiblility.launcher = false
                        }
                    }
                    Keys.onEscapePressed: searchField.forceActiveFocus()

                    // Stagger-in on model change
                    add: Transition {
                        NumberAnimation {
                            property: "opacity"; from: 0; to: 1
                            duration: 200
                        }
                        NumberAnimation {
                            property: "scale"; from: 0.82; to: 1
                            duration: 260
                            easing.type: Easing.OutBack
                        }
                    }
                    displaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration:   220
                            easing.type: Easing.OutCubic
                        }
                    }

                    delegate: Item {
                        id: appDelegate
                        required property int index
                        required property var modelData

                        width:  appGrid.cellWidth
                        height: appGrid.cellHeight

                        // Staggered entrance
                        property real entranceP: 0
                        NumberAnimation on entranceP {
                            from: 0; to: 1
                            duration: 340
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animation.curves.emphasizedDecel
                            running: launcher.visible
                        }

                        opacity: entranceP
                        scale:   0.78 + 0.22 * entranceP

                        Rectangle {
                            id: appCard
                            anchors { fill: parent; margins: 5 }
                            radius: Appearance.rounding.large
                            color: {
                                if (appGrid.currentIndex === appDelegate.index)
                                    return Appearance.colors.colSecondaryContainer
                                if (appHoverMa.containsMouse)
                                    return Appearance.colors.colLayer2Hover
                                return "transparent"
                            }
                            Behavior on color { ColorAnimation { duration: 130 } }

                            scale: appHoverMa.pressed
                                ? 0.92
                                : appHoverMa.containsMouse ? 1.04 : 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: appHoverMa.pressed ? 90 : 280
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Appearance.animation.curves.expressiveFastSpatial
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: Appearance.margin.verysmall
                                width: parent.width - 12

                                // Icon
                                Item {
                                    width: 48; height: 48
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    // Fallback background
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Appearance.rounding.normal
                                        color: Qt.rgba(
                                            Appearance.colors.colPrimary.r,
                                            Appearance.colors.colPrimary.g,
                                            Appearance.colors.colPrimary.b, 0.13)
                                        visible: !appIcon.visible
                                    }

                                    StyledText {
                                        anchors.centerIn: parent
                                        text: appDelegate.modelData.name.charAt(0).toUpperCase()
                                        font.family:    Appearance.font.family.title
                                        font.pixelSize: Metrics.fontSize("big")
                                        font.weight:    Font.Bold
                                        color: Appearance.colors.colPrimary
                                        visible: !appIcon.visible
                                    }

                                    Image {
                                        id: appIcon
                                        anchors.fill: parent
                                        source: AppRegistry.iconForDesktopIcon(
                                            appDelegate.modelData.icon) || ""
                                        fillMode: Image.PreserveAspectFit
                                        visible: status === Image.Ready
                                        smooth: true; mipmap: true; asynchronous: true
                                    }
                                }

                                // Name
                                StyledText {
                                    width: parent.width
                                    text: appDelegate.modelData.name
                                    font.pixelSize: Metrics.fontSize("smaller")
                                    font.weight: appGrid.currentIndex === appDelegate.index
                                        ? Font.Medium : Font.Normal
                                    color: appGrid.currentIndex === appDelegate.index
                                        ? Appearance.colors.colOnSecondaryContainer
                                        : Appearance.colors.colOnLayer1
                                    horizontalAlignment: Text.AlignHCenter
                                    elide:    Text.ElideRight
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 2
                                    Behavior on color { ColorAnimation { duration: 130 } }
                                }
                            }

                            MouseArea {
                                id: appHoverMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape:  Qt.PointingHandCursor
                                onEntered: appGrid.currentIndex = appDelegate.index
                                onClicked: {
                                    console.log("TYPE:", typeof appDelegate.modelData)
                                    console.log("EXEC:", appDelegate.modelData.execString)
                                    console.log("ID:", appDelegate.modelData.id)
                                    Apps.launch(appDelegate.modelData)
                                    Quickshell.execDetached(["kitty"])
                                    Globals.visiblility.launcher = false
                                }
                            }
                        }
                    }
                }
            }


            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.margin.small

                StyledText {
                    text: launcher.displayApps.length + " apps"
                    font.pixelSize: Metrics.fontSize("smallest")
                    color: Appearance.colors.colSubtext
                    opacity: 0.55
                }

                Item { Layout.fillWidth: true }

                // Keyboard hint pills
                Repeater {
                    model: [
                        { icon: "keyboard_return", label: "Launch" },
                        { icon: "keyboard_tab",    label: "Navigate" },
                        { icon: "escape",          label: "Close" },
                    ]

                    RowLayout {
                        required property var modelData
                        spacing: 4

                        Rectangle {
                            height: 20
                            width:  hintSymbol.implicitWidth + 10
                            radius: 4
                            color:  Appearance.colors.colLayer2

                            MaterialSymbol {
                                id: hintSymbol
                                anchors.centerIn: parent
                                icon:     parent.parent.modelData.icon
                                iconSize: Metrics.iconSize(12)
                                color:    Appearance.colors.colSubtext
                            }
                        }

                        StyledText {
                            text:           parent.modelData.label
                            font.pixelSize: Metrics.fontSize("smallest")
                            color: Appearance.colors.colSubtext
                            opacity: 0.5
                        }
                    }
                }
            }
        }
    }


    IpcHandler {
        target: "launcher"
        function toggle() {
            Globals.visiblility.launcher = !Globals.visiblility.launcher
        }
    }
}