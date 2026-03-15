pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string query: ""
    property alias filteredApps: appsModel

    property var launchCounts: ({})
    property var lastUsed: ({})

    readonly property string _dataDir: "/home/andrex/.config/quickshell/lucyna/data"

    // Lee los datos guardados desde data/applauncher.json al iniciar
    property FileView _dataFile: FileView {
        path: root._dataDir + "/applauncher.json"
        onTextChanged: {
            if (!text.trim()) return
            try {
                const data = JSON.parse(text)
                if (data.launchCounts) root.launchCounts = data.launchCounts
                if (data.lastUsed)     root.lastUsed     = data.lastUsed
            } catch(e) {}
        }
    }

    // Process para escribir a disco
    property Process _saveProc: Process {
        running: false
    }

    function launch(entry) {
        entry.execute()
        _recordLaunch(entry.id)
    }

    function _score(appId) {
        const count = root.launchCounts[appId] ?? 0
        if (count === 0) return 0
        const hoursElapsed = (Date.now() - (root.lastUsed[appId] ?? 0)) / 3_600_000
        return count / Math.log2(hoursElapsed + 2)
    }

    function _recordLaunch(appId) {
        const newCounts   = Object.assign({}, root.launchCounts, { [appId]: (root.launchCounts[appId] ?? 0) + 1 })
        const newLastUsed = Object.assign({}, root.lastUsed,     { [appId]: Date.now() })
        root.launchCounts = newCounts
        root.lastUsed     = newLastUsed
        _saveProc.command = [
            "python3", "-c",
            "import sys,os; p=sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p,'w').write(sys.argv[2])",
            root._dataDir + "/applauncher.json",
            JSON.stringify({launchCounts: newCounts, lastUsed: newLastUsed})
        ]
        _saveProc.running = true
    }

    ScriptModel {
        id: appsModel
        values: {
            const q      = root.query.trim().toLowerCase()
            const limit  = q === "" ? 6 : 20
            const apps   = DesktopEntries.applications
                ? [...DesktopEntries.applications.values]
                : []
            const filtered = q === ""
                ? apps
                : apps.filter(e =>
                    e.name?.toLowerCase().includes(q)
                    || e.genericName?.toLowerCase().includes(q)
                    || e.keywords?.some(k => k.toLowerCase().includes(q))
                )
            return filtered.sort((a, b) => {
                const diff = root._score(b.id) - root._score(a.id)
                return diff !== 0 ? diff : a.name.localeCompare(b.name)
            }).slice(0, limit)
        }
    }
}
