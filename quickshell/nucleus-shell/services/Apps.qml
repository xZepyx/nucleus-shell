pragma Singleton

import "../modules/functions/fuzzy/fuzzysort.js" as Fuzzy
import Quickshell

Singleton {
    id: root

    readonly property list<DesktopEntry> list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    readonly property list<var> preppedApps: list.map(a => ({
                name: Fuzzy.prepare(a.name),
                comment: Fuzzy.prepare(a.comment),
                entry: a
            }))

    function fuzzyQuery(search: string): var { // idk why list<DesktopEntry> doesn't work
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

    function cleanExec(exec) {
        return exec
            .replace(/%[fFuUdDnNickvm]/g, "") // remove all field codes
            .replace(/\s+/g, " ")             // normalize spaces
            .trim()
    }

    function launch(entry: DesktopEntry): void {
        let exec = entry.execString

        if (!exec) return

        // Case 1: already a shell command
        if (exec.startsWith("sh -c")) {
            Quickshell.execDetached(["sh", "-lc", exec.slice(5).trim()])
            return
        }

        // Clean field codes
        exec = cleanExec(exec)

        // Case 2: normal command
        Quickshell.execDetached(["sh", "-lc", exec])
    }
}