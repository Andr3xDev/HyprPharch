pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    AppLauncherState — private state for the app launcher module.

    Tracks launch frequency and recency to sort results,
    persists counts across sessions via a JSON file, and filters
    desktop entries in real time against the current query.
*/
Singleton {
    id: root

    // Public state
    property string query: ""
    property alias  filteredApps: appsModel

    // Persistence state
    property var    launchCounts:     ({})
    property var    lastUsed:         ({})
    property string _pendingSaveJson: ""

    readonly property string _dataFilePath: Quickshell.env("HOME") + "/.config/quickshell/lucyna/modules/launchers/apps/data/applauncher.json"

    // Inline Python scripts keep the dependency footprint minimal
    readonly property string _loadScript:
        "import sys,json,pathlib; p=pathlib.Path(sys.argv[1]); d={'launchCounts':{},'lastUsed':{}};\n" +
        "try:\n" +
        " s=p.read_text() if p.exists() else ''\n" +
        " if s.strip():\n" +
        "  raw=json.loads(s)\n" +
        "  d['launchCounts']=raw.get('launchCounts', {})\n" +
        "  d['lastUsed']=raw.get('lastUsed', {})\n" +
        "except Exception:\n" +
        " pass\n" +
        "print(json.dumps(d))"

    readonly property string _saveScript:
        "import sys,os; p=sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p,'w').write(sys.argv[2])"

    Component.onCompleted: _loadFromDisk()

    // Disk I/O processes

    property Process _loadProc: Process {
        running: false
        command: ["python3", "-c", root._loadScript, root._dataFilePath]
        stdout: SplitParser {
            onRead: data => root._loadPersistedData(data)
        }
    }

    property Process _saveProc: Process {
        running: false
        onExited: {
            if (root._pendingSaveJson.length > 0) {
                const next = root._pendingSaveJson
                root._pendingSaveJson = ""
                root._writePersistedData(next)
            }
        }
    }

    // Public API

    function launch(entry) {
        entry.execute()
        _recordLaunch(_appKey(entry))
    }

    // Private

    function _appKey(entry) {
        return entry.id
            || entry.desktopId
            || entry.desktopFile
            || entry.execString
            || entry.command
            || entry.name
            || ""
    }

    function _loadFromDisk() {
        if (_loadProc.running) return
        _loadProc.running = true
    }

    function _loadPersistedData(text) {
        if (!text || !text.trim()) return
        try {
            const data   = JSON.parse(text)
            const counts = {}
            const used   = {}

            for (const key of Object.keys(data.launchCounts ?? {})) {
                const v = Number(data.launchCounts[key])
                if (Number.isFinite(v) && v > 0) counts[key] = v
            }
            for (const key of Object.keys(data.lastUsed ?? {})) {
                const v = Number(data.lastUsed[key])
                if (Number.isFinite(v) && v > 0) used[key] = v
            }

            root.launchCounts = counts
            root.lastUsed     = used
        } catch (_) {}
    }

    function _recordLaunch(appId) {
        if (!appId) return
        const newCounts   = Object.assign({}, root.launchCounts, { [appId]: (root.launchCounts[appId] ?? 0) + 1 })
        const newLastUsed = Object.assign({}, root.lastUsed,     { [appId]: Date.now() })
        root.launchCounts = newCounts
        root.lastUsed     = newLastUsed
        _writePersistedData(JSON.stringify({ launchCounts: newCounts, lastUsed: newLastUsed }))
    }

    function _writePersistedData(payloadJson) {
        if (_saveProc.running) {
            _pendingSaveJson = payloadJson
            return
        }
        _saveProc.command = ["python3", "-c", root._saveScript, root._dataFilePath, payloadJson]
        _saveProc.running = true
    }

    // Filtered + sorted app model

    ScriptModel {
        id: appsModel
        values: {
            const q     = root.query.trim().toLowerCase()
            const limit = q === "" ? 20 : 30
            const apps  = DesktopEntries.applications
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
                const aKey = root._appKey(a), bKey = root._appKey(b)

                const countDiff = (root.launchCounts[bKey] ?? 0) - (root.launchCounts[aKey] ?? 0)
                if (countDiff !== 0) return countDiff

                const lastDiff = (root.lastUsed[bKey] ?? 0) - (root.lastUsed[aKey] ?? 0)
                if (lastDiff !== 0) return lastDiff

                return a.name.localeCompare(b.name)
            }).slice(0, limit)
        }
    }
}
