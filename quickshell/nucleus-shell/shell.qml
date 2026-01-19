import Quickshell 
import QtQuick 

import qs.config
import qs.plugins
import qs.services
import qs.modules.interface.bar
import qs.modules.interface.background
import qs.modules.interface.powermenu
import qs.modules.interface.launcher
import qs.modules.interface.notifications
import qs.modules.interface.overlays
import qs.modules.interface.sidebarRight
import qs.modules.interface.settings
import qs.modules.interface.lockscreen

ShellRoot {
    id: shellroot 

    // Load modules

    LazyLoader {
        id: barLoader
        source: Contracts.bar
        active: Config.runtime.bar.enabled
    }

    LazyLoader {
        id: backgroundLoader
        source: Contracts.background
        active: Config.runtime.appearance.background.enabled
    }

    LazyLoader {
        id: powerMenuLoader
        source: Contracts.powerMenu
        active: Globals.visiblility.powermenu
    }

    LazyLoader {
        id: launcherLoader
        source: Contracts.launcher
        active: true
    }

    LazyLoader {
        id: notificationsLoader
        source: Contracts.notifications
        active: Config.runtime.notifications.enabled
    }

    LazyLoader {
        id: overlaysLoader
        source: Contracts.overlays
        active: Config.runtime.overlays.enabled
    }

    LazyLoader {
        id: sidebarRightLoader
        source: Contracts.sidebarRight
        active: Globals.visiblility.sidebarRight
    }

    LazyLoader {
        id: lockScreenLoader
        source: Contracts.lockScreen
        active: true
    }

    Settings { }

    Ipc { }

    UpdateNotifier { }

    PluginHost { }

}