import QtQuick
pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell

Singleton {
    id: root
    property QtObject visiblility
    property QtObject states

    visiblility: QtObject {
        property bool powermenu: false
        property bool launcher: false
        property bool sidebarRight: false
        property bool sidebarLeft: false
    }

    states: QtObject {
        property bool settingsOpen: false
        property bool intelligenceWindowOpen: false
    }

}
