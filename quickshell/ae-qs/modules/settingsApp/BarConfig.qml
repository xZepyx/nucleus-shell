import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.settings
import qs.widgets

ContentMenu {
    title: "Bar"
    description: "Adjust the bar's look."

    ContentCard {
        StyledText {
            text: "Bar"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            StyledText {
                text: "Position"
                font.pixelSize: 16
            }

            RowLayout {
                spacing: 8

                Repeater {
                    model: ['Top', 'Bottom']

                    delegate: StyledButton {
                        property bool isTop: modelData.toLowerCase() === "top"

                        text: modelData
                        implicitWidth: 0
                        Layout.fillWidth: true // make both buttons full width
                        checked: Shell.flags.bar.atTop === isTop
                        // Rounded corners for visual consistency
                        topLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        topRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        onClicked: Shell.setNestedValue("bar.atTop", isTop)
                    }

                }

            }

        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable the bar."
            prefField: "bar.enabled"
        }

        StyledSwitchOption {
            title: "Floating Bar"
            description: "Whether to keep the bar floating."
            prefField: "bar.floating"
        }

        StyledSwitchOption {
            title: "Goth Corners"
            description: "Enable or disable Goth Corners."
            prefField: "bar.gothCorners"
        }


    }

    ContentCard {
        StyledText {
            text: "Bar Rounding & Size"
            font.pixelSize: 20
            font.bold: true
        }

        NumberStepper {
            label: "Bar Height"
            description: "Adjust the height of the bar."
            prefField: "bar.height"
            minimum: 40
            maximum: 128
        }

        NumberStepper {
            label: "Bar Radius"
            description: "Adjust the radius of the bar."
            prefField: "bar.radius"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Module Container Radius"
            description: "Adjust the radius of the module container."
            prefField: "bar.moduleRadius"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Island Radius"
            description: "Adjust the radius of the island radius."
            prefField: "bar.islandRadius"
            minimum: 10
            maximum: 128
        }

        StyledText {
            text: "Bar Module Values"
            font.pixelSize: 20
            font.bold: true
        }

        NumberStepper {
            label: "Workspace Indicators"
            description: "Adjust workspaces indicators on the bar."
            prefField: "bar.modules.workspaces.numWorkspaces"
            minimum: 1
            maximum: 10
        }

    }

}
