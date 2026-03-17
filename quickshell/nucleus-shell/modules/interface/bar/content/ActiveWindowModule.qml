import qs.config
import qs.modules.components
import qs.modules.functions
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Item {
    id: container

    property string displayName: screen?.name ?? ""
    property var barConfig: ConfigResolver.bar(displayName)

    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    property Toplevel activeToplevel: Compositor.isWorkspaceOccupied(Compositor.focusedWorkspaceId)
        ? Compositor.activeToplevel
        : null

    readonly property string appId: activeToplevel?.appId ?? ""
    readonly property string windowTitle: activeToplevel?.title ?? ""

    implicitHeight: barConfig.modules.height
    implicitWidth: row.implicitWidth + 24

    function cleanTitle(title) {
        if (!title)
            return ""

        title = title.replace(/[●⬤○◉◌◎]/g, "")

        title = title
            .replace(/\s*[|—]\s*/g, " - ")
            .replace(/\s+/g, " ")
            .trim()

        const parts = title.split(" - ").map(p => p.trim()).filter(Boolean)

        if (parts.length === 1)
            return parts[0]

        const app = parts[parts.length - 1]
        const context = parts[0]

        if (context && context !== app)
            return `${app} · ${context}`

        return app
    }

    function trimTitle(text, max) {
        if (!text)
            return ""

        if (text.length <= max)
            return text

        const separators = [" · ", " - ", " | "]

        for (let s of separators) {
            if (text.includes(s)) {
                const parts = text.split(s)
                const left = parts[0]
                const right = parts.slice(1).join(s)

                if (left.length + right.length + 5 <= max)
                    return `${left}${s}${right}`

                const rmax = Math.floor(max * 0.55)

                if (right.length > rmax)
                    return `${left}${s}${right.slice(0, rmax)}…`

                return `${left}${s}${right}`
            }
        }

        const half = Math.floor(max / 2)

        return text.substring(0, half)
             + "…"
             + text.substring(text.length - half)
    }

    function resolveIcon(appId) {

        if (!appId)
            return "application-x-executable"

        let id = appId.toLowerCase()

        const map = {
            "org.mozilla.firefox": "firefox",
            "firefox": "firefox",

            "org.gnome.nautilus": "nautilus",
            "nautilus": "nautilus",

            "chromium": "chromium",
            "google-chrome": "google-chrome",
            "code": "code",
            "code-oss": "code",
            "kitty": "kitty",
            "alacritty": "alacritty",
            "discord": "discord",
            "spotify": "spotify",
            "steam": "steam",
            "zen": "zen-browser",
            "zen-browser": "zen-browser"
        }

        if (map[id])
            return map[id]

        if (id.includes(".")) {
            const parts = id.split(".")
            return parts[parts.length - 1]
        }

        return id
    }

    Rectangle {
        anchors.fill: parent

        visible: barConfig.position === "top"
              || barConfig.position === "bottom"

        radius: barConfig.modules.radius
        color: Appearance.m3colors.m3surfaceContainerLow
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Item {
            id: iconContainer

            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: Math.min(container.implicitHeight * 0.55, 20)
            Layout.preferredHeight: Layout.preferredWidth

            Item {
                anchors.fill: parent

                Image {
                    id: appIcon
                    anchors.fill: parent

                    visible: activeToplevel

                    source: "image://icon/" + resolveIcon(appId)

                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    antialiasing: true
                }

                MaterialSymbol {
                    anchors.centerIn: parent
                    visible: !activeToplevel

                    text: "desktop_windows"
                    font.pixelSize: Metrics.iconSize(18)
                }
            }
        }

        StyledText {
            id: titleText

            Layout.alignment: Qt.AlignVCenter

            text: {
                if (!activeToplevel)
                    return "Desktop"

                const cleaned = cleanTitle(windowTitle)
                return trimTitle(cleaned, 34)
            }

            font.pixelSize: Appearance.font.size.small
            elide: Text.ElideRight
        }
    }
}
