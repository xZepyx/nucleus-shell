import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
pragma Singleton

Singleton {
    id: root

    property string hostname: ""
    property string username: ""
    property string osIcon: ""
    property string osName: ""
    property string kernelVersion: ""
    property string architecture: ""
    property string uptime: ""
    property string qsVersion: ""
    property string swapUsage: "—"
    property real swapPercent: 0
    property string ipAddress: "—"
    property int runningProcesses: 0
    property int loggedInUsers: 0
    property string ramUsage: "—"
    property real ramPercent: 0
    property string cpuLoad: "—"
    property real cpuPercent: 0
    property string diskUsage: "—"
    property real diskPercent: 0
    property string cpuTemp: "—"
    property string keyboardLayout: "none"
    property real cpuTempPercent: 0
    readonly property var osIcons: ({
        "almalinux": "",
        "alpine": "",
        "arch": "󰣇",
        "archcraft": "",
        "arcolinux": "",
        "artix": "",
        "centos": "",
        "debian": "",
        "devuan": "",
        "elementary": "",
        "endeavouros": "",
        "fedora": "",
        "freebsd": "",
        "garuda": "",
        "gentoo": "",
        "hyperbola": "",
        "kali": "",
        "linuxmint": "󰣭",
        "mageia": "",
        "openmandriva": "",
        "manjaro": "",
        "neon": "",
        "nixos": "",
        "opensuse": "",
        "suse": "",
        "sles": "",
        "sles_sap": "",
        "opensuse-tumbleweed": "",
        "parrot": "",
        "pop": "",
        "raspbian": "",
        "rhel": "",
        "rocky": "",
        "slackware": "",
        "solus": "",
        "steamos": "",
        "tails": "",
        "trisquel": "",
        "ubuntu": "",
        "vanilla": "",
        "void": "",
        "zorin": ""
    })

    Process {
        id: usernameProc

        running: true
        command: ["whoami"]

        stdout: StdioCollector {
            onStreamFinished: {
                var clean = text.trim();
                if (clean !== root.username)
                    root.username = clean;

            }
        }

    }

    Process {
        id: hostnameProc

        command: ["hostname"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var cleanH = text.trim();
                root.hostname = cleanH !== "" ? cleanH : "aelyx";
            }
        }

    }

    Process {
        running: true
        command: ["sh", "-c", "source /etc/os-release && echo \"$NAME|$VERSION|$PRETTY_NAME|$LOGO|$ID\""]

        stdout: StdioCollector {
            onStreamFinished: {
                var parts = text.trim().split("|");
                if (parts.length >= 5) {
                    root.osName = parts[2]; // prettyName as osName
                    var osId = parts[4];
                    root.osIcon = root.osIcons[osId] || "";
                }
            }
        }

    }

    FileView {
        path: '/proc/uptime'
        watchChanges: true
        onFileChanged: {
            const seconds = parseFloat(text().trim().split(" ")[0]);
            const d = Math.floor(seconds / 86400);
            const h = Math.floor((seconds % 86400) / 3600);
            const m = Math.floor((seconds % 3600) / 60);
            var out = "Up ";
            if (d > 0)
                out += d + "d, ";

            if (h > 0)
                out += h + "h, ";

            out += m + "m";
            root.uptime = out;
        }
        onLoaded: {
            const seconds = parseFloat(text().trim().split(" ")[0]);
            const d = Math.floor(seconds / 86400);
            const h = Math.floor((seconds % 86400) / 3600);
            const m = Math.floor((seconds % 3600) / 60);
            var out = "Up ";
            if (d > 0)
                out += d + "d, ";

            if (h > 0)
                out += h + "h, ";

            out += m + "m";
            root.uptime = out;
        }
    }

    Process {
        running: true
        command: ['qs', '--version']

        stdout: StdioCollector {
            onStreamFinished: {
                root.qsVersion = text.trim().split(',')[0].trim().replace("quickshell ", "");
                Config.updateKey("shell.qsVersion", text.trim().split(',')[0].trim().replace("quickshell ", ""));
            }
        }

    }

    Process {
        id: kernelProc

        running: true
        command: ["uname", "-r"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.kernelVersion = text.trim();
            }
        }

    }

    Process {
        id: archProc

        running: true
        command: ["uname", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.architecture = text.trim();
            }
        }

    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            ramProc.running = true;
            cpuProc.running = true;
            cpuTempProc.running = true;
            diskProc.running = true;
        }
    }

    Process {
        id: ramProc

        running: true
        command: ["free", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.split("\n").find((l) => {
                    return l.startsWith("Mem:");
                });
                if (!line)
                    return ;

                const p = line.split(/\s+/);
                const total = parseInt(p[1]);
                const used = parseInt(p[2]);
                ramPercent = used / total;
                ramUsage = `${used}/${total} MB`;
            }
        }

    }

    Process {
        id: cpuProc

        running: true
        command: ["uptime"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/load average: ([0-9.]+)/);
                if (!match)
                    return ;

                const load = parseFloat(match[1]);
                cpuPercent = Math.min(load / 4, 1);
                cpuLoad = load.toFixed(2);
            }
        }

    }

    Process {
        id: cpuTempProc

        running: true
        command: ["sh", "-c", `
        for f in /sys/class/hwmon/hwmon*/temp*_input; do
            name=$(cat $(dirname "$f")/name 2>/dev/null)
            case "$name" in
                coretemp|k10temp|cpu_thermal)
                    cat "$f"
                    exit
                    ;;
            esac
        done
        `]

        stdout: StdioCollector {
            onStreamFinished: {
                const raw = parseInt(text.trim());
                if (isNaN(raw))
                    return ;

                const c = raw / 1000; // millideg → deg C
                root.cpuTemp = `${Math.round(c)}°C`;
                // normalize: 30°C → 0%, 95°C → 100%
                const min = 30;
                const max = 95;
                root.cpuTempPercent = Math.max(0, Math.min(1, (c - min) / (max - min)));
            }
        }

    }

    Process {
        id: diskProc

        running: true
        command: ["df", "-h", "/"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length < 2)
                    return ;

                const p = lines[1].split(/\s+/);
                const used = p[2];
                const total = p[1];
                const percent = parseInt(p[4]) / 100;
                diskPercent = percent;
                diskUsage = `${used}/${total}`;
            }
        }

    }

    Process {
        id: keyboardLayoutProc
        running: true

        command: [
            "sh", "-c",
            "hyprctl devices -j | jq -r '.keyboards[] | select(.name == \"at-translated-set-2-keyboard\") | .layout'"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const layout = text.trim()
                if (!layout)
                    return

                root.keyboardLayout = layout
            }
        }
    }

    Process {
        id: swapProc

        running: true
        command: ["sh", "-c", "free -m | grep Swap"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim();
                if (!line)
                    return ;

                const parts = line.split(/\s+/);
                const total = parseInt(parts[1]);
                const used = parseInt(parts[2]);
                root.swapPercent = used / total;
                root.swapUsage = `${used} / ${total} MB`;
            }
        }

    }

    Process {
        id: ipProc

        running: true
        command: ["sh", "-c", "hostname -I | awk '{print $1}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                const ip = text.trim();
                if (ip)
                    root.ipAddress = ip;

            }
        }

    }

    Process {
        id: runningProcCount

        running: true
        command: ["sh", "-c", "ps -e --no-headers | wc -l"]

        stdout: StdioCollector {
            onStreamFinished: {
                SystemDetails.runningProcesses = parseInt(text.trim());
            }
        }

    }

    Process {
        id: loggedInUsers

        running: true
        command: ["who", "-q"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length > 0)
                    SystemDetails.loggedInUsers = lines[lines.length - 1].replace("# users=", "").trim();

            }
        }

    }

}
