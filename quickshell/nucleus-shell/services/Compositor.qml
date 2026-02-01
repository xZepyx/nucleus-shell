pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // compositor stuff
    property string detectedCompositor: ""
    
    readonly property var backend: {
        if (detectedCompositor === "niri")
            return Niri
        if (detectedCompositor === "hyprland")
            return Hyprland
        return null
    }

    function require(compositor) { // This function can be effectively used to detect check requirements for a feature
        if (Array.isArray(compositors)) {
            return compositors.includes(detectedCompositor);
        }
        return compositors === detectedCompositor;
    }

    // Unified api
    property string title: backend?.title ?? ""
    property bool isFullscreen: backend?.isFullscreen ?? false
    property string layout: backend?.layout ?? "Tiled"
    property int focusedWorkspaceId: backend?.focusedWorkspaceId ?? 1
    property var workspaces: backend?.workspaces ?? []
    property var windowList: backend?.windowList ?? []
    property bool initialized: backend?.initialized ?? true
    property int workspaceCount: backend?.workspaceCount ?? 0

    function changeWorkspace(id) {
        backend?.changeWorkspace?.(id)
    }

    function changeWorkspaceRelative(delta) {
        backend?.changeWorkspaceRelative?.(delta)
    }

    function isWorkspaceOccupied(id) {
        return backend?.isWorkspaceOccupied?.(id) ?? false
    }

    function focusedWindowForWorkspace(id) {
        return backend?.focusedWindowForWorkspace?.(id) ?? null
    }

    // process to detect compositor
    Process {
        command: ["sh", "-c", "echo \"$XDG_CURRENT_DESKTOP $XDG_SESSION_DESKTOP\""]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return

                const val = data.trim().toLowerCase()

                if (val.includes("hyprland")) {
                    root.detectedCompositor = "hyprland"
                } else if (val.includes("niri")) {
                    root.detectedCompositor = "niri"
                }
            }
        }
    }

    signal stateChanged()

    Connections {
        target: backend
        function onStateChanged() {
            root.stateChanged()
        }
    }

}
