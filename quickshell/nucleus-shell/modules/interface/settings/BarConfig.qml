import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.components
import qs.services

ContentMenu {
    title: "Bar"
    description: "Adjust the bar's look."

    ContentCard {
        StyledText {
            text: "Bar"
            font.pixelSize: Metrics.fontSize(20)
            font.bold: true
        }

        ColumnLayout {
            StyledText {
                text: "Position"
                font.pixelSize: Metrics.fontSize(16)
            }

            RowLayout {
                spacing: Metrics.spacing(8)

                Repeater {
                    model: ["Top", "Bottom", "Left", "Right"]

                    delegate: StyledButton {
                        property string pos: modelData.toLowerCase()

                        text: modelData
                        implicitWidth: 0
                        Layout.fillWidth: true
                        checked: Config.runtime.bar.position === pos
                        topLeftRadius: Metrics.radius("normal")
                        topRightRadius: Metrics.radius("normal")
                        bottomLeftRadius: Metrics.radius("normal")
                        bottomRightRadius: Metrics.radius("normal")
                        onClicked: Config.updateKey("bar.position", pos)
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

        StyledSwitchOption {
            title: "Merged Layout"
            description: "Merge the  bar to screen."
            prefField: "bar.merged"
        }

    }

    ContentCard {
        StyledText {
            text: "Bar Rounding & Size"
            font.pixelSize: Metrics.fontSize(20)
            font.bold: true
        }

        NumberStepper {
            label: "Bar Density"
            description: "Adjust the height/density of the bar."
            prefField: "bar.density"
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
            prefField: "bar.modules.radius"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Module Height"
            description: "Adjust the height of the bar module's height."
            prefField: "bar.modules.height"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Workspace Indicators"
            description: "Adjust the workspace indicators on the workspace module."
            prefField: "bar.modules.workspaces.workspaceIndicators"
            minimum: 1
            maximum: 10
        }

    }

    ContentCard {
        StyledText {
            text: "Bar Modules"
            font.pixelSize: Metrics.fontSize(20)
            font.bold: true
        }

        StyledText {
            text: "Workspaces"
            font.pixelSize: Metrics.fontSize(18)
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable workspace module."
            prefField: "bar.modules.workspaces.enabled"
        }

        StyledSwitchOption {
            title: "Show App Icons"
            description: "Show opened app icons (Hyprland Only)."
            enabled: !Config.runtime.bar.modules.workspaces.showJapaneseNumbers && Compositor.require("hyprland")
            opacity: !Config.runtime.bar.modules.workspaces.showJapaneseNumbers && Compositor.require("hyprland") ? 1 : 0.8
            prefField: "bar.modules.workspaces.showAppIcons"
        }

        StyledSwitchOption {
            title: "Show Japanese Numbers"
            description: "Enable or disable japanese indicators."
            enabled: !Config.runtime.bar.modules.workspaces.showAppIcons
            opacity: !Config.runtime.bar.modules.workspaces.showAppIcons ? 1 : 0.8
            prefField: "bar.modules.workspaces.showJapaneseNumbers"
        }

        StyledText {
            text: "Status Icons"
            font.pixelSize: Metrics.fontSize(18)
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable status icons module."
            prefField: "bar.modules.statusIcons.enabled"
        }

        StyledSwitchOption {
            title: "Show Wifi Status"
            description: "Enable or disable wifi status."
            prefField: "bar.modules.statusIcons.networkStatusEnabled"
        }

        StyledSwitchOption {
            title: "Show Bluetooth Status"
            description: "Enable or disable bluetooth status."
            prefField: "bar.modules.statusIcons.bluetoothStatusEnabled"
        }

        StyledText {
            text: "System Stats"
            font.pixelSize: Metrics.fontSize(18)
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable system stats module."
            prefField: "bar.modules.systemUsage.enabled"
        }

        StyledSwitchOption {
            title: "Show Cpu Usage Stats"
            description: "Enable or disable cpu usage stats."
            prefField: "bar.modules.systemUsage.cpuStatsEnabled"
        }

        StyledSwitchOption {
            title: "Show Memory Usage Stats"
            description: "Enable or disable ram usage stats."
            prefField: "bar.modules.systemUsage.memoryStatsEnabled"
        }

        StyledSwitchOption {
            title: "Show Cpu Temperature Stats"
            description: "Enable or disable cpu temperature stats."
            prefField: "bar.modules.systemUsage.tempStatsEnabled"
        }

    }

}
