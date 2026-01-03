import qs.services
import qs.widgets 
import qs.config
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ContentMenu {
    title: ""

    ContentCard {
        StyledSwitchOption {
            title: "Notification Daemon";
            description: "Enabled or disable builtin Aelyx notification daemon."
            prefField: "misc.notificationDaemonEnabled"
        }

        StyledSwitchOption {
            title: "Focus Mode";
            description: "Enabled or disable focus mode."
            prefField: "misc.dndEnabled"
        }
        StyledSwitchOption {
            title: "Show this on startup";
            description: "Show the first time menu on startup."
            prefField: "misc.showFirstTimeMenuOnStartup"
        }
    }
}
