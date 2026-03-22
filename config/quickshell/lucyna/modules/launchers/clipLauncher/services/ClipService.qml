pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string query: ""
    property alias filtered: _filtered

    signal pasteCompleted()

    ListModel { id: _entries }
    ListModel { id: _filtered }

    Process {
        id: _listProc
        running: false
        command: ["cliphist", "list"]
        stdout: SplitParser {
            onRead: data => root._parseLine(data)
        }
        onExited: root._rebuildFilter()
    }

    Process {
        id: _pasteProc
        running: false
        onExited: root.pasteCompleted()
    }

    Process {
        id: _cleanupProc
        running: false
    }

    // Called by ClipLauncher.open() — defers loading until the launcher is actually opened
    function refresh() {
        _entries.clear()
        _filtered.clear()
        query = ""          // reset after clearing so _rebuildFilter runs on empty data (no-op)
        if (!_listProc.running)
            _listProc.running = true
    }

    // Called by ClipLauncher.close() — removes decoded image temp files
    function cleanup() {
        if (_cleanupProc.running) return
        _cleanupProc.command = ["sh", "-c", "rm -f /tmp/qs_clip_*"]
        _cleanupProc.running = true
    }

    function _parseLine(line) {
        if (!line.trim()) return
        const tab = line.indexOf('\t')
        if (tab < 0) return
        const id = line.substring(0, tab)
        const preview = line.substring(tab + 1).trim()
        const isImage = preview.startsWith("[[") && preview.includes("binary")
        _entries.append({
            clipId: id,
            preview: isImage ? "(imagen)" : preview,
            type: isImage ? "image" : "text"
        })
    }

    onQueryChanged: _rebuildFilter()

    function _rebuildFilter() {
        _filtered.clear()
        const q = query.trim().toLowerCase()
        for (let i = 0; i < _entries.count; i++) {
            const item = _entries.get(i)
            if (!q || item.preview.toLowerCase().includes(q))
                _filtered.append(item)
        }
    }

    function paste(id) {
        if (_pasteProc.running) return
        _pasteProc.command = ["sh", "-c", "cliphist decode " + id + " | wl-copy"]
        _pasteProc.running = true
    }
}
