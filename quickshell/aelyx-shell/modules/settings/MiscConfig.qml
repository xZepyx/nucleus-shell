import qs.services
import qs.widgets 
import qs.config
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ContentMenu {
    title: "Misc"
    description: "Adjust misc settings."

    ContentCard {
        StyledSwitchOption {
            title: "Notification Daemon";
            description: "Enabled or disable builtin notification daemon."
            prefField: "misc.notificationDaemonEnabled"
        }
    }

    ContentCard {
        RowLayout {
            id: releaseChannelSelector
            property string title: "Release Channel"
            property string description: "Choose the release channel for updates."
            property string prefField: ''

            ColumnLayout {
                StyledText { text: releaseChannelSelector.title; font.pixelSize: 16;  }
                StyledText { text: releaseChannelSelector.description; font.pixelSize: 12; }
            }
            Item { Layout.fillWidth: true }

            StyledDropDown {
                label: "Type"
                model: ["Stable", "Edge (indev)"]

                currentIndex: Shell.flags.shellInfo.channel === "edge" ? 1 : 0

                onSelectedIndexChanged: (index) => {
                    Shell.setNestedValue(
                        "shellInfo.channel",
                        index === 1 ? "edge" : "stable"
                    )
                    UpdateNotifier.notified = false
                }
            }


        }

    }
}
