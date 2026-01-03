import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.config
import qs.widgets

ContentMenu {
    title: "Appearance"
    description: "Adjust how the desktop looks like."

    ContentCard {
        // ---------- Dark Mode Row ----------
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            ColumnLayout {
                StyledText {
                    text: "Dark mode"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "Whether to use dark color schemes."
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledSwitch {
                checked: Shell.flags.appearance.theme === "dark"
                onToggled: {
                    Quickshell.execDetached({
                        "command": ['qs', '-c', 'aelyx-shell', 'ipc', 'call', 'global', "toggleTheme"]
                    });
                }
            }

        }

        ColumnLayout {
            StyledText {
                text: "Color Generation Schemes:"
                font.pixelSize: 16
            }

            GridLayout {
                rows: 2
                columns: 4

                Repeater {
                    model: ["scheme-content", "scheme-expressive", "scheme-fidelity", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow", "scheme-tonal-spot"]

                    delegate: StyledButton {
                        text: modelData
                        clip: true
                        Layout.fillWidth: true
                        implicitWidth: 0
                        // Selected state
                        checked: Shell.flags.appearance.colorScheme === modelData
                        // Rounded corners depending on whether this is first/last item
                        topLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                        bottomLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                        topRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                        bottomRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                        onClicked: {
                            Shell.setNestedValue("appearance.colorScheme", modelData);
                            Quickshell.execDetached(["qs", "-c", "aelyx-shell", "ipc", "call", "global", "regenColors"]);
                        }
                    }

                }

            }

        }

    }

    ContentCard {
        StyledText {
            text: "Clock"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Show Clock"
            description: "Whether to show or disable the clock on the background."
            prefField: "background.showClock"
        }

        StyledText {
            text: "Clock Position"
            font.pixelSize: 16
            font.bold: true
        }

        RowLayout {
            spacing: 8

            StyledButton {
                text: "Top Left"
                checked: Shell.flags.background.clockPosition === "top-left"
                onClicked: Shell.setNestedValue("background.clockPosition", "top-left")
                Layout.fillWidth: true
            }

            StyledButton {
                text: "Top Right"
                checked: Shell.flags.background.clockPosition === "top-right"
                onClicked: Shell.setNestedValue("background.clockPosition", "top-right")
                Layout.fillWidth: true
            }

            StyledButton {
                text: "Bottom Left"
                checked: Shell.flags.background.clockPosition === "bottom-left"
                onClicked: Shell.setNestedValue("background.clockPosition", "bottom-left")
                Layout.fillWidth: true
            }

            StyledButton {
                text: "Bottom Right"
                checked: Shell.flags.background.clockPosition === "bottom-right"
                onClicked: Shell.setNestedValue("background.clockPosition", "bottom-right")
                Layout.fillWidth: true
            }

        }

    }

}
