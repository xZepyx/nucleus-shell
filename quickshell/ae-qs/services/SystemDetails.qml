import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property string hostname: ""
    property string username: ""
    property string osIcon: ""
    property string osName: ""
    property string kernelVersion: ""
    property string architecture: ""
    property bool hasBattery: false
    property int batteryPercent: 0
    property bool onAC: false
    property string uptime: ""
    property string qsVersion: ""
    property string swapUsage: "—"
    property real swapPercent: 0
    property string diskUsage: "—"
    property string ipAddress: "—"
    property int runningProcesses: 0
    property int loggedInUsers: 0
    
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

    Process {
        id: batteryCheckProc

        running: true
        command: ["sh", "-c", "ls /sys/class/power_supply | grep BAT || true"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.hasBattery = text.trim().length > 0;
                if (root.hasBattery)
                    batteryPercentProc.running = true;

            }
        }

    }

    Process {
        id: batteryPercentProc

        running: false
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null"]

        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseInt(text.trim());
                if (!isNaN(v))
                    root.batteryPercent = v;

            }
        }

    }

    Process {
        id: acProc

        running: false
        command: ["sh", "-c", "cat /sys/class/power_supply/AC*/online 2>/dev/null"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.onAC = text.trim() === "1";
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
        id: diskProc

        running: true
        command: ["sh", "-c", "df -h --total | grep total"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim();
                if (!line)
                    return ;

                const parts = line.split(/\s+/);
                root.diskUsage = `${parts[2]} used / ${parts[1]} total (${parts[4]})`;
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
