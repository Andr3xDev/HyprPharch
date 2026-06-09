pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "./tokens" as Tokens
import "./themes" as ThemeVariants

/*!
    ThemeManager — Singleton + Strategy pattern.

    Manages the active theme, persists the selection to disk, and exposes
    a single semantic token API:

      colors.surface.primary / spacing.md / typography.size.sm …

    Switching ThemeManager.currentTheme propagates to all tokens via binding.
*/
QtObject {
    id: themeManager

    // ── Active theme ──────────────────────────────────────
    property string currentTheme: "abysal-obsidian"
    property string _pendingSaveJson: ""

    readonly property var availableThemes: [
        "abysal-obsidian",
        "abysal-marble"
    ]

    // ── Persistence path ──────────────────────────────────
    readonly property string _dataFilePath: Quickshell.env("HOME") + "/.config/quickshell/lucyna/core/theme/data/theme.json"

    readonly property string _loadScript:
        "import sys,json,pathlib; p=pathlib.Path(sys.argv[1]); d={'theme':'abysal-obsidian'};\n" +
        "try:\n" +
        " s=p.read_text() if p.exists() else ''\n" +
        " if s.strip():\n" +
        "  raw=json.loads(s)\n" +
        "  d['theme']=raw.get('theme','abysal-obsidian')\n" +
        "except Exception:\n" +
        " pass\n" +
        "print(json.dumps(d))"

    readonly property string _saveScript:
        "import sys,os; p=sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p,'w').write(sys.argv[2])"

    // ── I/O processes ─────────────────────────────────────
    property Process _loadProc: Process {
        running: false
        command: ["python3", "-c", themeManager._loadScript, themeManager._dataFilePath]
        stdout: SplitParser {
            onRead: data => themeManager._loadPersistedTheme(data)
        }
    }

    property Process _saveProc: Process {
        running: false
        onExited: {
            if (themeManager._pendingSaveJson.length > 0) {
                const nextJson = themeManager._pendingSaveJson
                themeManager._pendingSaveJson = ""
                themeManager._writePersistedTheme(nextJson)
            }
        }
    }

    Component.onCompleted: {
        _loadFromDisk()
    }

    function _loadFromDisk() {
        if (_loadProc.running) return
        _loadProc.running = true
    }

    function _loadPersistedTheme(text) {
        if (!text || !text.trim()) return
        try {
            const data = JSON.parse(text)
            const loaded = data.theme
            if (loaded && availableThemes.includes(loaded))
                currentTheme = loaded
        } catch (e) {}
    }

    function _writePersistedTheme(payloadJson) {
        if (_saveProc.running) {
            _pendingSaveJson = payloadJson
            return
        }
        _saveProc.command = ["python3", "-c", _saveScript, _dataFilePath, payloadJson]
        _saveProc.running = true
    }

    // ── Raw palette lookup ────────────────────────────────
    readonly property var _palettes: ({
        "abysal-obsidian": ThemeVariants.AbyssalDark,
        "abysal-marble":   ThemeVariants.AbyssalLight
    })

    readonly property var _activePalette: _palettes[currentTheme] ?? _palettes["abysal-obsidian"]

    // ── SEMANTIC API ──────────────────────────────────────
    // Colors — semantic grouping
    readonly property QtObject colors: QtObject {
        readonly property QtObject surface: QtObject {
            readonly property color primary:   themeManager._activePalette.base
            readonly property color secondary: themeManager._activePalette.surface
            readonly property color overlay:   themeManager._activePalette.highlight1
        }
        readonly property QtObject on: QtObject {
            readonly property color surface:      themeManager._activePalette.text
            readonly property color surfaceMuted: themeManager._activePalette.color8
        }
        readonly property QtObject accent: QtObject {
            readonly property color primary:   themeManager._activePalette.color1
            readonly property color secondary: themeManager._activePalette.color2
            readonly property color tertiary:  themeManager._activePalette.color5
        }
        readonly property QtObject status: QtObject {
            readonly property color error:   themeManager._activePalette.color4
            readonly property color warning: themeManager._activePalette.color3
            readonly property color success: themeManager._activePalette.color1
        }
        readonly property QtObject highlight: QtObject {
            readonly property color subtle: themeManager._activePalette.highlight1
            readonly property color medium: themeManager._activePalette.highlight2
            readonly property color strong: themeManager._activePalette.highlight3
        }
        readonly property color border:     themeManager._activePalette.color9
        readonly property real  barOpacity: themeManager._activePalette.barOpacity
    }

    // Spacing scale
    readonly property QtObject spacing: QtObject {
        readonly property int xs:  4
        readonly property int sm:  8
        readonly property int md:  12
        readonly property int lg:  16
        readonly property int xl:  24
        readonly property int xxl: 32
    }

    // Typography scale
    readonly property QtObject typography: QtObject {
        readonly property QtObject family: QtObject {
            readonly property string sans:  "Sans Serif"
            readonly property string mono:  "Monospace"
            readonly property string icons: "Symbols Nerd Font"
        }
        readonly property QtObject size: QtObject {
            readonly property int xs: 8
            readonly property int sm: 10
            readonly property int md: 11
            readonly property int lg: 13
            readonly property int xl: 16
        }
        readonly property int iconSize: 12
    }

    // Radius scale
    readonly property QtObject radius: QtObject {
        readonly property int none: 0
        readonly property int sm:   4
        readonly property int md:   6
        readonly property int lg:   8
        readonly property int xl:   12
        readonly property int full: 9999
    }

    // Motion tokens
    readonly property QtObject motion: QtObject {
        readonly property QtObject duration: QtObject {
            readonly property int fast:     100
            readonly property int standard: 200
            readonly property int slow:     350
        }
        readonly property QtObject easing: QtObject {
            readonly property int standard:   Easing.OutCubic
            readonly property int decelerate: Easing.OutQuart
            readonly property int accelerate: Easing.InCubic
        }
    }

    // ── Public API ────────────────────────────────────────

    function setTheme(themeName) {
        if (availableThemes.includes(themeName)) {
            currentTheme = themeName
            _writePersistedTheme(JSON.stringify({ theme: themeName }))
            return true
        }
        return false
    }

    function getNextTheme() {
        const idx = availableThemes.indexOf(currentTheme)
        return availableThemes[(idx + 1) % availableThemes.length]
    }

    function getThemeDisplayName(themeName) {
        const p = _palettes[themeName]
        return p ? p.name : themeName
    }
}
