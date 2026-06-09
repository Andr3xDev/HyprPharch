pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/*!
    ClipState — private state for the clipboard launcher module.

    Loads entries from cliphist, filters by query, and handles paste,
    single-entry delete, and full wipe operations.
*/
Singleton {
    id: root

    property string query: ""
    property alias  filtered: _filtered

    signal pasteCompleted()

    ListModel { id: _entries  }
    ListModel { id: _filtered }

    // ── Processes ────────────────────────────────────────

    Process {
        id: _listProc
        running: false
        command: ["cliphist", "list"]
        stdout: SplitParser { onRead: data => root._parseLine(data) }
        onExited: root._rebuildFilter()
    }

    Process {
        id: _pasteProc
        running: false
        onExited: root.pasteCompleted()
    }

    Process { id: _deleteProc; running: false }

    Process {
        id: _wipeProc
        running: false
        onExited: root.refresh()
    }

    Process {
        id: _cleanupProc
        running: false
    }

    // ── Public API ───────────────────────────────────────

    function refresh() {
        _entries.clear()
        _filtered.clear()
        query = ""
        if (!_listProc.running) _listProc.running = true
    }

    function cleanup() {
        if (_cleanupProc.running) return
        _cleanupProc.command = ["sh", "-c", "rm -f /tmp/qs_clip_*"]
        _cleanupProc.running = true
    }

    function paste(id) {
        if (_pasteProc.running) return
        _pasteProc.command = ["sh", "-c", "cliphist decode " + id + " | wl-copy"]
        _pasteProc.running = true
    }

    function deleteEntry(rawLine, clipId) {
        if (_deleteProc.running) return
        _deleteProc.command = ["sh", "-c",
            "printf '%s\\n' " + _shellQuote(rawLine) + " | cliphist delete"]
        _deleteProc.running = true
        _removeFromModels(clipId)
    }

    function clearAll() {
        if (_wipeProc.running) return
        _wipeProc.command = ["cliphist", "wipe"]
        _wipeProc.running = true
    }

    // ── Private ──────────────────────────────────────────

    onQueryChanged: _rebuildFilter()

    function _parseLine(line) {
        if (!line.trim()) return
        const tab = line.indexOf('\t')
        if (tab < 0) return
        const id      = line.substring(0, tab)
        const preview = line.substring(tab + 1).trim()
        const isImage = preview.startsWith("[[") && preview.includes("binary")
        _entries.append({
            clipId:  id,
            preview: isImage ? "(image)" : preview,
            type:    isImage ? "image" : "text",
            rawLine: line
        })
    }

    function _rebuildFilter() {
        _filtered.clear()
        const q = query.trim().toLowerCase()
        for (let i = 0; i < _entries.count; i++) {
            const item = _entries.get(i)
            if (!q || item.preview.toLowerCase().includes(q))
                _filtered.append(item)
        }
    }

    function _removeFromModels(clipId) {
        for (let i = 0; i < _entries.count;  i++) {
            if (_entries.get(i).clipId  === clipId) { _entries.remove(i);  break }
        }
        for (let i = 0; i < _filtered.count; i++) {
            if (_filtered.get(i).clipId === clipId) { _filtered.remove(i); break }
        }
    }

    function _shellQuote(s) {
        return "'" + s.replace(/'/g, "'\\''") + "'"
    }
}
