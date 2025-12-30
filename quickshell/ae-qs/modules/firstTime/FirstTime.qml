//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import Qt.labs.settings
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.settings
import qs.widgets

FloatingWindow {
    id: root

    implicitWidth: 900
    implicitHeight: 600
    title: "Welcome to aelyx-shell"
    color: Appearance.m3colors.m3background
    Component.onCompleted: {
        root.visible = GlobalStates.visible_firstTimeMenu;
    }

    Item {
        anchors.fill: parent

        SwipeView {
            id: view

            anchors.fill: parent
            interactive: true

            WelcomePage {
            }

            AppearancePage {
            }

            BarPage {
            }

            WallpaperPage {
            }

            MiscPage {
            }

            FinalPage {
            }

        }

        Rectangle {
            height: 2
            width: parent.width - Appearance.margin.verylarge
            color: Appearance.m3colors.m3outlineVariant
            opacity: 0.6

            anchors {
                top: view.top
                topMargin: segmentedIndicator.height + Appearance.margin.verysmall
                horizontalCenter: view.horizontalCenter
            }

        }

        Rectangle {
            id: activeTabIndicator

            height: 2
            width: 96
            radius: 1
            color: Appearance.m3colors.m3primary
            x: (segmentedIndicator.width / view.count) * view.currentIndex + (segmentedIndicator.width / view.count - width) / 2

            anchors {
                top: segmentedIndicator.bottom
                topMargin: Appearance.margin.verysmall
            }

            Behavior on x {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }

            }

        }

        Item {
            id: segmentedIndicator

            height: 56
            width: parent.width

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            Row {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: [{
                        "icon": "waving_hand",
                        "text": "Welcome"
                    }, {
                        "icon": "colors",
                        "text": "Appearance"
                    }, {
                        "icon": "toolbar",
                        "text": "Bar"
                    }, {
                        "icon": "wallpaper",
                        "text": "Wallpaper"
                    }, {
                        "icon": "build",
                        "text": "Miscellaneous"
                    }, {
                        "icon": "check_circle",
                        "text": "All Set"
                    }]

                    Item {
                        width: segmentedIndicator.width / view.count
                        height: parent.height

                        MouseArea {
                            anchors.fill: parent
                            onClicked: view.currentIndex = index
                        }

                        MaterialSymbol {
                            icon: modelData.icon
                            iconSize: Appearance.font.size.huge
                            color: view.currentIndex === index ? Appearance.m3colors.m3primary : Appearance.m3colors.m3onSurfaceVariant

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: 12
                            }

                        }

                        StyledText {
                            text: modelData.text
                            font.pixelSize: Appearance.font.size.large
                            font.weight: Font.Medium
                            color: view.currentIndex === index ? Appearance.m3colors.m3primary : Appearance.m3colors.m3onSurfaceVariant

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.bottom
                                bottomMargin: 0
                            }

                        }

                    }

                }

            }

        }

    }

    IpcHandler {
        function open() {
            GlobalStates.visible_firstTimeMenu = true;
        }

        target: "firstTimeMenu"
    }

}
