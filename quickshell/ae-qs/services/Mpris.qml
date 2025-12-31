import Quickshell
import QtQuick
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property string albumArtist: "No Artist"
    property string albumTitle: "No Media"
    property string artUrl: ""

    property int positionSec: 0
    property int lengthSec: 0

    function formatTime(seconds) {
        const m = Math.floor(seconds / 60)
        const s = Math.floor(seconds % 60)
        return `${m.toString().padStart(2,"0")}:${s.toString().padStart(2,"0")}`
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: mprisProc.running = true
    }

    Process {
        id: mprisProc
        command: [
            "playerctl",
            "metadata",
            "--format",
            "{{xesam:artist}}|{{xesam:title}}|{{mpris:artUrl}}|{{position}}|{{mpris:length}}"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split("|")
                if (parts.length < 5)
                    return

                /* Artist */
                root.albumArtist = parts[0] !== ""
                    ? parts[0]
                    : "No Artist"

                /* Title */
                root.albumTitle = parts[1] !== ""
                    ? parts[1]
                    : "No Media"

                /* Artwork */
                if (parts[2] !== root.artUrl)
                    root.artUrl = parts[2]

                /* Position (seconds) */
                let pos = parseFloat(parts[3])
                if (!isNaN(pos))
                    root.positionSec = Math.floor(pos)

                /* Length (microseconds → seconds) */
                let len = parseFloat(parts[4])
                if (!isNaN(len))
                    root.lengthSec = Math.floor(len / 1_000_000)
            }
        }
    }
}
