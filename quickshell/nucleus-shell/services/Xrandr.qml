import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

/*

    Why use this service? Good question.
    :- Cause xrandr works with all compositors to fetch monitor data. 

*/

Item {
    id: root

    // Array of monitor objects: { name, width, height, x, y, physWidth, physHeight }
    property var monitors: []

    // Refresh monitors every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: xrandrProc.running = true
    }

    Process {
        id: xrandrProc
        command: ["bash", "-c", "xrandr --query | grep ' connected '"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: { // I don't even know wtf is this I can't explain shit
                const lines = text.trim().split("\n")
                root.monitors = lines.map(line => {
                    const m = line.match(/^(\S+)\sconnected\s(\d+)x(\d+)\+(\d+)\+(\d+).*?(\d+)mm\sx\s(\d+)mm$/)
                    if (!m) return null
                    return {
                        name: m[1],
                        width: parseInt(m[2]),
                        height: parseInt(m[3]),
                        x: parseInt(m[4]),
                        y: parseInt(m[5]),
                        physWidth: parseInt(m[6]),
                        physHeight: parseInt(m[7])
                    }
                }).filter(m => m)
            }
        }
    }

    function getMonitor(name) {
        return monitors.find(m => m.name === name) || null
    }
}