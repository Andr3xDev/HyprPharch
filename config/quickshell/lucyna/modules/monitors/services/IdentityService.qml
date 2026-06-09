pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../infra"

/*!
    IdentityService — Registry + Singleton.

    Maintains a serial → identity map backed by data/identities.json.
    Allows monitors to keep a stable alias and tags regardless of which
    physical port they are connected to.

    Public API:
      resolve(serial)                      → identity object | null
      register(serial, make, model, alias, tags)  → persists new identity
      update(serial, changes)              → updates alias and/or tags
*/
QtObject {
    id: root

    // ── Signals ───────────────────────────────────────────
    // Emitted once the initial load from disk completes (success or empty).
    // MonitorService waits for this before its first refresh() to avoid
    // overwriting saved aliases with defaults during the startup race.
    signal loaded()

    // ── State ─────────────────────────────────────────────
    property var _registry: ({})   // { [serial]: identity }

    // ── Paths ──────────────────────────────────────────────
    readonly property string _dataFile:
        Quickshell.env("HOME") + "/.config/quickshell/lucyna/modules/monitors/data/identities.json"

    // ── Load script ───────────────────────────────────────
    readonly property string _loadScript: [
        "import sys, json, pathlib",
        "p = pathlib.Path(sys.argv[1])",
        "d = {'version': 1, 'identities': []}",
        "try:",
        "    s = p.read_text() if p.exists() else ''",
        "    if s.strip(): d = json.loads(s)",
        "except Exception:",
        "    pass",
        "print(json.dumps(d))"
    ].join("\n")

    // ── I/O processes ─────────────────────────────────────
    property Process _loadProc: Process {
        running: false
        command: ["python3", "-c", root._loadScript, root._dataFile]
        stdout: SplitParser {
            onRead: function(line) { root._onLoaded(line) }
        }
    }

    property FileWriter _fileWriter: FileWriter {
        onWriteCompleted: function(ok, errorMessage) {
            if (!ok) console.warn("IdentityService: failed to persist identities.json —", errorMessage)
        }
    }

    // ── Lifecycle ─────────────────────────────────────────
    Component.onCompleted: {
        _loadProc.running = true
    }

    // ── Private ───────────────────────────────────────────
    function _onLoaded(text) {
        if (text && text.trim()) {
            try {
                const data = JSON.parse(text)
                const reg = {}
                for (const id of (data.identities || []))
                    reg[id.serial] = id
                _registry = reg
            } catch (e) {
                console.warn("IdentityService: failed to parse identities.json:", e)
            }
        }
        loaded()  // always signal completion so MonitorService can proceed
    }

    function _persist() {
        _fileWriter.write(
            _dataFile,
            JSON.stringify({ version: 1, identities: Object.values(_registry) }, null, 2)
        )
    }

    // ── Public API ────────────────────────────────────────
    function resolve(serial) {
        return _registry[serial] ?? null
    }

    /*!
        Find-or-Create (Upsert). Returns the existing identity or creates and
        persists a new one with alias = model name. This keeps the side effect
        (registration) inside the service that owns the data, so callers
        (MonitorAdapter) stay as pure transformations from their perspective.
    */
    function resolveOrRegister(serial, make, model) {
        const existing = resolve(serial)
        if (existing) return existing
        const alias = (model && model !== serial) ? model : serial
        register(serial, make, model, alias, [])
        return resolve(serial)
    }

    function register(serial, make, model, alias, tags) {
        if (_registry[serial]) return
        const entry = { serial: serial, make: make, model: model, alias: alias, tags: tags.slice() }
        _registry = Object.assign({}, _registry, { [serial]: entry })
        _persist()
    }

    function update(serial, changes) {
        if (!_registry[serial]) return
        _registry = Object.assign({}, _registry, { [serial]: Object.assign({}, _registry[serial], changes) })
        _persist()
    }
}
