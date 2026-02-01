import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: niriItem

    signal stateChanged()
    property string title: ""
    property bool isFullscreen: false
    property string layout: "Tiled"
    property int focusedWorkspaceId: 1
    property var workspaces: []
    property var workspaceCache: ({
    })
    property bool initialized: false

    function changeWorkspace(id) {
        sendSocketCommand(niriCommandSocket, {
            "Action": {
                "focus_workspace": {
                    "reference": {
                        "Id": id
                    }
                }
            }
        });
        dispatchProc.command = ["niri", "msg", "action", "focus-workspace", id.toString()];
        dispatchProc.running = true;
    }

    function isWorkspaceOccupied(id) {
        for (const ws of workspaces) {
            if (ws.id === id)
                return true
        }
        return false
    }

    function focusedWindowForWorkspace(id) {
        // Niri does not expose per-workspace focused windows
        // We return the global focused window only if workspace matches
        if (focusedWorkspaceId === id) {
            return {
                title: title,
                fullscreen: isFullscreen
            }
        }
        return null
    }

    function changeWorkspaceRelative(delta) {
        const cmd = delta > 0 ? "focus-workspace-down" : "focus-workspace-up";
        dispatchProc.command = ["niri", "msg", "action", cmd];
        dispatchProc.running = true;
    }

    function sendSocketCommand(sock, command) {
        if (sock.connected)
            sock.write(JSON.stringify(command) + "\n");

    }

    function startEventStream() {
        sendSocketCommand(niriEventStream, "EventStream");
    }

    function updateWorkspaces() {
        sendSocketCommand(niriCommandSocket, "Workspaces");
    }

    function updateWindows() {
        sendSocketCommand(niriCommandSocket, "Windows");
    }

    function updateFocusedWindow() {
        sendSocketCommand(niriCommandSocket, "FocusedWindow");
    }

    function recollectWorkspaces(workspacesData) {
        const workspacesList = [];
        workspaceCache = {
        };
        for (const ws of workspacesData) {
            const wsData = {
                "id": (ws.idx !== undefined ? ws.idx + 1 : ws.id),
                "internalId": ws.id,
                "idx": ws.idx,
                "name": ws.name || "",
                "output": ws.output || "",
                "isFocused": ws.is_focused === true,
                "isActive": ws.is_active === true
            };
            workspacesList.push(wsData);
            workspaceCache[ws.id] = wsData;
            if (wsData.isFocused)
                focusedWorkspaceId = wsData.id;
            stateChanged()

        }
        workspacesList.sort((a, b) => {
            return a.id - b.id;
        });
        workspaces = workspacesList;
    }

    function recollectFocusedWindow(win) {
        stateChanged()
        if (win && win.title) {
            title = win.title || "~";
            isFullscreen = win.is_fullscreen || false;
            layout = "Tiled"; // Niri is tiled mostly
        } else {
            title = "~";
            isFullscreen = false;
            layout = "Tiled";
        }
    }

    Component.onCompleted: {
        if (Quickshell.env("NIRI_SOCKET")) {
            niriCommandSocket.connected = true;
            niriEventStream.connected = true;
            initialized = true;
        }
    }

    Socket {
        id: niriCommandSocket

        path: Quickshell.env("NIRI_SOCKET") || ""
        connected: false
        onConnectedChanged: {
            if (connected) {
                updateWorkspaces();
                updateFocusedWindow();
            }
        }

        parser: SplitParser {
            onRead: function(line) {
                if (!line.trim())
                    return ;

                try {
                    const data = JSON.parse(line);
                    if (data && data.Ok) {
                        const res = data.Ok;
                        if (res.Workspaces)
                            recollectWorkspaces(res.Workspaces);
                        else if (res.FocusedWindow)
                            recollectFocusedWindow(res.FocusedWindow);
                    }
                } catch (e) {
                    console.warn("Niri socket parse error:", e);
                }
            }
        }

    }

    Socket {
        id: niriEventStream

        path: Quickshell.env("NIRI_SOCKET") || ""
        connected: false
        onConnectedChanged: {
            if (connected)
                startEventStream();

        }

        parser: SplitParser {
            onRead: (data) => {
                if (!data.trim())
                    return ;

                try {
                    // Re-fetch to be safe and get full state
                    // Check if new window is focused

                    const event = JSON.parse(data.trim());
                    if (event.WorkspacesChanged)
                        recollectWorkspaces(event.WorkspacesChanged.workspaces);
                    else if (event.WorkspaceActivated)
                        updateWorkspaces();
                    else if (event.WindowFocusChanged)
                        updateFocusedWindow();
                    else if (event.WindowOpenedOrChanged)
                        updateFocusedWindow();
                    else if (event.WindowClosed)
                        updateFocusedWindow();
                } catch (e) {
                    console.warn("Niri event stream parse error:", e);
                }
            }
        }

    }

    Process {
        id: dispatchProc
    }

}
