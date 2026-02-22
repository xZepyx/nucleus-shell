import qs.config
import qs.modules.components
import qs.modules.functions
import qs.services
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts

Item {
    id: container
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    property Toplevel activeToplevel: Compositor.isWorkspaceOccupied(Compositor.focusedWorkspaceId)
        ? Compositor.activeToplevel
        : null

    implicitWidth: row.implicitWidth + 30
    implicitHeight: Config.runtime.bar.modules.height

    function simplifyTitle(title) {
        if (!title)
            return ""

        title = title.replace(/[●⬤○◉◌◎]/g, "") // Symbols to remove

        // Normalize separators
        title = title
            .replace(/\s*[|—]\s*/g, " - ")
            .replace(/\s+/g, " ")
            .trim()

        const parts = title.split(" - ").map(p => p.trim()).filter(Boolean)

        if (parts.length === 1)
            return parts[0]

        // Known app names (extend freely my fellow contributors)
        const apps = [
            "Firefox", "Mozilla Firefox",
            "Chromium", "Google Chrome",
            "Neovim", "VS Code", "Code",
            "Kitty", "Alacritty", "Terminal",
            "Discord", "Spotify", "Steam",
            "Settings - Nucleus", "Settings"
        ]

        let app = ""
        for (let i = parts.length - 1; i >= 0; i--) { // loop over
            for (let a of apps) {
                if (parts[i].includes(a)) {
                    app = a
                    break
                }
            }
            if (app) break
        }

        if (!app)
            app = parts[parts.length - 1]

        const context = parts.find(p => p !== app)

        return context ? `${app} · ${context}` : app
    }


    function formatAppId(appId) { // Random ass function to make it look good
        if (!appId || appId.length === 0)
            return "";

        // split on dashes/underscores
        const parts = appId.split(/[-_]/);
        // capitalize each segment
        for (let i = 0; i < parts.length; i++) {
            const p = parts[i];
            parts[i] = p.charAt(0).toUpperCase() + p.slice(1);
        }
        return parts.join("-");
    }

    /* Column {
        id: col
        anchors.centerIn: parent

        StyledText {
            id: workspaceText
            font.pixelSize: Metrics.fontSize("smallie")
            text: {
                if (!activeToplevel)
                    return "Desktop"

                const id = activeToplevel.appId || ""

                return id // Just for aesthetics
            }
            horizontalAlignment: Text.AlignHCenter
        }

        StyledText {
            id: titleText
            text: StringUtils.shortText(simplifyTitle(activeToplevel?.title, 24) || `Workspace ${Hyprland.focusedWorkspaceId}`)
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Metrics.fontSize("smalle")
        }
    } */

    Rectangle {
        visible: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom")
        color: Appearance.m3colors.m3paddingContainer
        anchors.fill: parent
        height: 34 
        width: row.height + 30
        radius: Config.runtime.bar.modules.radius
    }


    RowLayout {
        id: row
        spacing: 12
        anchors.centerIn: parent

        MaterialSymbol {
            icon: "desktop_windows"
            rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
        }

        StyledText {
            text: StringUtils.shortText(simplifyTitle(activeToplevel?.title), 24) || `Workspace ${Hyprland.focusedWorkspaceId}`
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.size.small
        }        
    }

}