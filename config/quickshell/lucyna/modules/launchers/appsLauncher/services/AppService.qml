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
    property string _pendingSaveJson: ""

    readonly property string _dataDir: "/home/andrex/.config/quickshell/lucyna/data"
    readonly property string _dataFilePath: _dataDir + "/applauncher.json"
    readonly property string _loadScript: "import sys,json,pathlib; p=pathlib.Path(sys.argv[1]); d={'launchCounts':{},'lastUsed':{}};\ntry:\n s=p.read_text() if p.exists() else ''\n if s.strip():\n  raw=json.loads(s)\n  d['launchCounts']=raw.get('launchCounts', {})\n  d['lastUsed']=raw.get('lastUsed', {})\nexcept Exception:\n pass\nprint(json.dumps(d))"
    readonly property string _saveScript: "import sys,os; p=sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p,'w').write(sys.argv[2])"

    // Process para leer datos persistidos al iniciar
    property Process _loadProc: Process {
        running: false
        command: [
            "python3", "-c",
            root._loadScript,
            root._dataFilePath
        ]
        stdout: SplitParser {
            onRead: data => root._loadPersistedData(data)
        }
    }

    // Process para escribir a disco
    property Process _saveProc: Process {
        running: false
        onExited: {
            if (root._pendingSaveJson.length > 0) {
                const nextJson = root._pendingSaveJson
                root._pendingSaveJson = ""
                root._writePersistedData(nextJson)
            }
        }
    }

    Component.onCompleted: {
        root._loadFromDisk()
    }

    function _loadFromDisk() {
        if (_loadProc.running) return
        _loadProc.running = true
    }

    function _loadPersistedData(text) {
        if (!text || !text.trim()) return
        try {
            const data = JSON.parse(text)
            const counts = {}
            const used = {}
            const rawCounts = data.launchCounts ?? {}
            const rawUsed = data.lastUsed ?? {}

            for (const key of Object.keys(rawCounts)) {
                const value = Number(rawCounts[key])
                if (Number.isFinite(value) && value > 0)
                    counts[key] = value
            }

            for (const key of Object.keys(rawUsed)) {
                const value = Number(rawUsed[key])
                if (Number.isFinite(value) && value > 0)
                    used[key] = value
            }

            root.launchCounts = counts
            root.lastUsed = used
        } catch (e) {}
    }

    function _writePersistedData(payloadJson) {
        if (_saveProc.running) {
            _pendingSaveJson = payloadJson
            return
        }

        _saveProc.command = [
            "python3", "-c",
            root._saveScript,
            root._dataFilePath,
            payloadJson
        ]
        _saveProc.running = true
    }

    function launch(entry) {
        entry.execute()
        _recordLaunch(_appKey(entry))
    }

    function _appKey(entry) {
        return entry.id
            || entry.desktopId
            || entry.desktopFile
            || entry.execString
            || entry.command
            || entry.name
            || ""
    }

    function _recordLaunch(appId) {
        if (!appId) return
        const newCounts   = Object.assign({}, root.launchCounts, { [appId]: (root.launchCounts[appId] ?? 0) + 1 })
        const newLastUsed = Object.assign({}, root.lastUsed,     { [appId]: Date.now() })
        root.launchCounts = newCounts
        root.lastUsed     = newLastUsed
        _writePersistedData(JSON.stringify({ launchCounts: newCounts, lastUsed: newLastUsed }))
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
                const aKey = root._appKey(a)
                const bKey = root._appKey(b)

                const aCount = root.launchCounts[aKey] ?? 0
                const bCount = root.launchCounts[bKey] ?? 0
                const countDiff = bCount - aCount
                if (countDiff !== 0) return countDiff

                const aLast = root.lastUsed[aKey] ?? 0
                const bLast = root.lastUsed[bKey] ?? 0
                const lastDiff = bLast - aLast
                if (lastDiff !== 0) return lastDiff

                return a.name.localeCompare(b.name)
            }).slice(0, limit)
        }
    }
}
