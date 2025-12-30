import qs.settings
import qs.modules.bar
import qs.modules.background
import qs.modules.launcher
import qs.modules.overlays
import qs.modules.notifications
import qs.modules.sidebarRight
import qs.modules.sidebarLeft
import qs.modules.settingsApp
import qs.modules.powerMenu
import qs.modules.firstTime

import QtQuick 
import Quickshell  

ShellRoot {
    GlobalProcesses{}
    Background{}
    Bar{}
    Launcher{}
    Overlays{}
    Notification{}
    SidebarRight{}
    SidebarLeft{}
    Settings{}
    PowerMenu{}
    FirstTime{}
}