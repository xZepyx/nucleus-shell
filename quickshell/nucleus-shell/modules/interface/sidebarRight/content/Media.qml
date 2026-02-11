import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets 
import Quickshell.Io
import qs.config
import qs.modules.functions
import qs.modules.interface.notifications
import qs.modules.components
import qs.services

StyledRect {
    id: root

    Layout.fillWidth: true
    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainer

    ClippingRectangle {
        color: Appearance.colors.colLayer1
        radius: Metrics.radius("normal")
        implicitHeight: 90
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            spacing: Metrics.margin("small")

            ClippingRectangle {
                implicitWidth: 140
                implicitHeight: 140
                Layout.leftMargin: Metrics.margin("large")
                radius: Metrics.radius("normal")
                clip: true
                color: Appearance.colors.colLayer2

                Image {
                    anchors.fill: parent
                    source: Mpris.artUrl
                    fillMode: Image.PreserveAspectCrop
                    cache: true
                }

            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.rightMargin: Metrics.margin("small")
                spacing: Metrics.spacing(2)

                Text {
                    text: Mpris.albumTitle
                    elide: Text.ElideRight
                    Layout.maximumWidth: 190
                    font.family: Metrics.fontFamily("title")
                    font.pixelSize: Metrics.fontSize("hugeass")
                    font.bold: true
                    color: Appearance.colors.colOnLayer2
                }

                Text {
                    text: Mpris.albumArtist
                    elide: Text.ElideRight
                    Layout.maximumWidth: 160
                    font.family: Metrics.fontFamily("main")
                    font.pixelSize: Metrics.fontSize("normal")
                    color: Appearance.colors.colSubtext
                }

                RowLayout {

                    Layout.fillWidth: true
                    spacing: Metrics.spacing(12)

                    Process {
                        id: control
                    }

                    Button {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        onClicked: Quickshell.execDetached(["playerctl", "previous"])

                        background: Rectangle {
                            radius: Metrics.radius("large")
                            color: Appearance.colors.colLayer2
                        }

                        contentItem: MaterialSymbol {
                            anchors.centerIn: parent
                            icon: "skip_previous"
                            font.pixelSize: Metrics.fontSize(24)
                            color: Appearance.colors.colOnLayer2
                            fill: 1
                        }

                    }

                    Button {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42
                        onClicked: Quickshell.execDetached(["playerctl", "play-pause"])

                        background: Rectangle {
                            radius: Metrics.radius("full")
                            color: Appearance.colors.colPrimary
                        }

                        contentItem: MaterialSymbol {
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            icon: "play_arrow"
                            font.pixelSize: Metrics.fontSize(36)
                            color: Appearance.colors.colOnPrimary
                            fill: 1
                            
                        }

                    }

                    Button {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        onClicked: Quickshell.execDetached(["playerctl", "next"])

                        background: Rectangle {
                            radius: Metrics.radius("large")
                            color: Appearance.colors.colLayer2
                        }

                        contentItem: MaterialSymbol {
                            anchors.centerIn: parent
                            icon: "skip_next"
                            font.pixelSize: Metrics.fontSize(24)
                            color: Appearance.colors.colOnLayer2
                            fill: 1
                            
                        }

                    }

                }

                RowLayout {
                    Layout.topMargin: Metrics.margin(15)
                    Layout.fillWidth: true
                    spacing: Metrics.spacing(12)

                    Text {
                        text: Mpris.formatTime(Mpris.positionSec)
                        font.pixelSize: Metrics.fontSize("smallest")
                        color: Appearance.colors.colSubtext
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 20

                        Rectangle {
                            anchors.fill: parent
                            radius: Metrics.radius("full")
                            color: Appearance.colors.colLayer2
                        }

                        Rectangle {
                            width: parent.width * (Mpris.lengthSec > 0 ? Mpris.positionSec / Mpris.lengthSec : 0)
                            radius: Metrics.radius("full")
                            color: Appearance.colors.colPrimary

                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                        }

                    }

                    Text {
                        text: Mpris.formatTime(Mpris.lengthSec)
                        font.pixelSize: Metrics.fontSize("smallest")
                        color: Appearance.colors.colSubtext
                    }

                }

            }

        }

    }

}
