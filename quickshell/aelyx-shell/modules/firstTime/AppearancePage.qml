import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.config
import qs.widgets

ContentMenu {
    title: ""

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
                        "command": ['qs', '-c', 'ae-qs', 'ipc', 'call', 'global', "toggleTheme"]
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
                            Quickshell.execDetached(["qs", "-c", "ae-qs", "ipc", "call", "global", "regenColors"]);
                        }
                    }

                }

            }

        }

    }


    ContentCard {
        StyledText {
            text: "Desktop Clock"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Show Clock"
            description: "Whether to show or disable the clock on the background."
            prefField: "background.showClock"
        }

        NumberStepper {
            label: "X Offset"
            description: "Change the X offset of the clock."
            prefField: "background.clockX"
            minimum: 1
            maximum: 128
        }

        NumberStepper {
            label: "Y Offset"
            description: "Change the Y offset of the clock."
            prefField: "background.clockY"
            minimum: 1
            maximum: 128
        }

    }

}
