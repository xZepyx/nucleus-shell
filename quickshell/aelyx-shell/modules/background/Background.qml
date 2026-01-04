import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "clock/"
import qs.functions
import qs.config
import qs.widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        StaticWindow {
            id: backgroundContainer

            required property var modelData
            property string selectedWallpaper: ""

            function applyWallpaper() {
                Shell.setNestedValue("background.wallpaperPath", selectedWallpaper);
                GlobalProcesses.genThemeColors.running = true;
            }

            color: (backgroundImage.status === Image.Error) ? Appearance.colors.colLayer2 : "transparent"
            namespace: "aelyx:background"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            screen: modelData
            visible: Shell.ready && Shell.flags.background.wallpaperEnabled

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            Process {
                id: wallpaperProc

                command: ["bash", "-c", "~/.config/quickshell/aelyx-shell/scripts/interface/changebg.sh"]

                stdout: StdioCollector {
                    onStreamFinished: {
                        const out = text.trim();
                        if (out !== "null" && out.length > 0) {
                            selectedWallpaper = out;
                            applyWallpaper();
                        }
                    }
                }

            }

            Image {
                id: backgroundImage

                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: Shell.flags.background.wallpaperPath
            }


            Item {
                anchors.centerIn: parent
                visible: backgroundImage.status === Image.Error || Shell.flags.background.wallpaperPath === ""

                Rectangle {
                    width: 550
                    height: 400
                    radius: Appearance.rounding.windowRounding
                    color: "transparent" // It looks better somehow
                    anchors.centerIn: parent

                    ColumnLayout {
                        anchors.centerIn: parent
                        anchors.margins: Appearance.margin.normal
                        spacing: Appearance.margin.small

                        // Icon
                        MaterialSymbol {
                            text: "wallpaper"
                            font.pixelSize: Appearance.font.size.wildass
                            color: Appearance.colors.colOnLayer2
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Heading
                        StyledText {
                            text: "No Wallpaper Set"
                            font.pixelSize: Appearance.font.size.hugeass
                            font.bold: true
                            color: Appearance.colors.colOnLayer2
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Description
                        StyledText {
                            text: "Wallpaper Missing."
                            font.pixelSize: Appearance.font.size.small
                            color: Appearance.colors.colSubtext
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        // Action
                        StyledButton {
                            text: "Set wallpaper"
                            icon: "wallpaper"
                            secondary: true
                            Layout.alignment: Qt.AlignHCenter
                            onClicked: wallpaperProc.running = true
                        }

                    }

                }

            }

            Clock {
            }

            IpcHandler {
                function change() {
                    wallpaperProc.running = true;
                }

                target: "background"
            }

        }

    }

}
