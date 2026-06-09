pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "./tokens" as Tokens
import "./themes" as ThemeVariants

/*!
    ThemeManager — Singleton facade for the design token system.

    Single import point for all consumers. Manages the active theme,
    persists the selection to disk, and exposes the full token API:

      ThemeManager.colors.surface.primary     ← dynamic, reacts to currentTheme
      ThemeManager.spacing.md                 ← SpacingTokens.md
      ThemeManager.typography.size.sm         ← TypographyTokens.size.sm
      ThemeManager.radius.lg                  ← RadiusTokens.lg
      ThemeManager.motion.duration.standard   ← MotionTokens.duration.standard

    Static tokens (spacing, typography, radius, motion) are owned by their
    respective singleton files under ./tokens/. ThemeManager exposes them
    as pass-through references — no duplication.

    Color tokens are resolved inline because they depend on _activePalette,
    which changes at runtime. A pass-through reference cannot hold reactive
    bindings to an external dynamic value without a circular dependency.
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

    // ── Persistence ───────────────────────────────────────
    readonly property string _dataFilePath:
        Quickshell.env("HOME") + "/.config/quickshell/lucyna/core/theme/data/theme.json"

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

    Component.onCompleted: _loadFromDisk()

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

    // ── Palette resolution ────────────────────────────────
    readonly property var _palettes: ({
        "abysal-obsidian": ThemeVariants.AbyssalDark,
        "abysal-marble":   ThemeVariants.AbyssalLight
    })

    readonly property var _activePalette: _palettes[currentTheme] ?? _palettes["abysal-obsidian"]

    // ── Color tokens (dynamic — inline bindings to _activePalette) ─
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

    // ── Static token API (delegated — single source of truth in each file) ─
    readonly property var spacing:    Tokens.SpacingTokens
    readonly property var typography: Tokens.TypographyTokens
    readonly property var radius:     Tokens.RadiusTokens
    readonly property var motion:     Tokens.MotionTokens

    // ── Public API ────────────────────────────────────────
    function setTheme(themeName) {
        if (!availableThemes.includes(themeName)) return false
        currentTheme = themeName
        _writePersistedTheme(JSON.stringify({ theme: themeName }))
        return true
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
