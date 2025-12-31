import Quickshell
import QtQuick
import Quickshell.Io
pragma Singleton

Item {
    id: root

    // I have to make such services because quickshell services like Quickshell.Services.UPower don't work and are messy. 

    // Battery
    property int percentage: 0
    property string state: "unknown"
    property string iconName: ""
    property bool onBattery: false
    property bool charging: false
    property bool batteryPresent: false
    property bool rechargeable: false


    // Energy metrics 
    property real energyWh: 0
    property real energyFullWh: 0
    property real energyRateW: 0
    property real capacityPercent: 0

    // AC / system 
    property bool acOnline: false
    property bool lidClosed: false

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: upowerProc.running = true
    }

    Process {
        id: upowerProc
        command: ["upower", "-d"]

        stdout: StdioCollector {
            onStreamFinished: {
                const t = text

                /* ---------- DisplayDevice (preferred) ---------- */

                let m


                m = t.match(/DisplayDevice[\s\S]*?present:\s+(yes|no)/)
                if (m) {
                    root.batteryPresent = (m[1] === "yes")
                } else {
                    /* fallback: physical battery */
                    m = t.match(/battery_BAT\d+[\s\S]*?present:\s+(yes|no)/)
                    if (m)
                        root.batteryPresent = (m[1] === "yes")
                }

                /* ---------- Rechargeable ---------- */

                m = t.match(/DisplayDevice[\s\S]*?rechargeable:\s+(yes|no)/)
                if (m) {
                    root.rechargeable = (m[1] === "yes")
                }

                m = t.match(/DisplayDevice[\s\S]*?percentage:\s+(\d+)%/)
                if (m) root.percentage = parseInt(m[1])

                m = t.match(/DisplayDevice[\s\S]*?state:\s+([a-z\-]+)/)
                if (m) {
                    root.state = m[1]
                    root.charging = (m[1].includes("charge"))
                }

                m = t.match(/DisplayDevice[\s\S]*?icon-name:\s+'([^']+)'/)
                if (m) root.iconName = m[1]

                m = t.match(/DisplayDevice[\s\S]*?energy:\s+([\d.]+)\s+Wh/)
                if (m) root.energyWh = parseFloat(m[1])

                m = t.match(/DisplayDevice[\s\S]*?energy-full:\s+([\d.]+)\s+Wh/)
                if (m) root.energyFullWh = parseFloat(m[1])

                m = t.match(/DisplayDevice[\s\S]*?energy-rate:\s+([\d.]+)\s+W/)
                if (m) root.energyRateW = parseFloat(m[1])

                /* ---------- Physical battery (extra info) ---------- */

                m = t.match(/capacity:\s+([\d.]+)%/)
                if (m) root.capacityPercent = parseFloat(m[1])

                /* ---------- Daemon / system ---------- */

                m = t.match(/on-battery:\s+(yes|no)/)
                if (m) root.onBattery = (m[1] === "yes")

                m = t.match(/lid-is-closed:\s+(yes|no)/)
                if (m) root.lidClosed = (m[1] === "yes")

                /* ---------- AC adapter ---------- */

                m = t.match(/line-power[\s\S]*?online:\s+(yes|no)/)
                if (m) root.acOnline = (m[1] === "yes")
            }
        }
    }
}
