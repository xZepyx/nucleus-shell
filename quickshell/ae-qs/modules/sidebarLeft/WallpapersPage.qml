import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.functions
import qs.modules.sidebarRight
import qs.services
import qs.settings
import qs.widgets

Item {
    id: wallpapersPage

    FolderListModel {
        id: wallpaperModel

        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showDirs: false
        showDotAndDotDot: false
    }

    // EMPTY STATE
    StyledText {
        visible: wallpaperModel.count === 0
        text: "Put some wallpapers in\n~/Pictures/Wallpapers"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Appearance.m3colors.m3onSurfaceVariant
        font.pixelSize: Appearance.font.size.large
        anchors.centerIn: parent
    }

    // WALLPAPER LIST
    ListView {
        anchors.topMargin: 90
        visible: wallpaperModel.count > 0
        anchors.fill: parent
        model: wallpaperModel
        spacing: Appearance.margin.normal
        clip: true

        delegate: Item {
            width: ListView.view.width
            height: 240

            StyledRect {
                id: imgContainer

                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                radius: Appearance.rounding.normal
                color: Appearance.m3colors.m3surfaceContainerLow
                layer.enabled: true

                Image {
                    id: wallImg

                    anchors.fill: parent
                    source: fileUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    clip: true
                }

                StyledText {
                    anchors.centerIn: parent
                    text: "Unsupported / Corrupted Image"
                    visible: wallImg.status === Image.Error
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Shell.setNestedValue("background.wallpaperPath", fileUrl);
                        Quickshell.execDetached(["qs", "-c", "ae-qs", "ipc", "call", "global", "regenColors"]);
                    }
                    cursorShape: Qt.PointingHandCursor
                }

                layer.effect: OpacityMask {

                    maskSource: Rectangle {
                        width: imgContainer.width
                        height: imgContainer.height
                        radius: imgContainer.radius
                    }

                }

            }

        }

    }

}
