import QtQuick
import Quickshell.Io

/*!
    FileWriter — Template Method pattern.

    Fixed algorithm for atomic file writes:
      1. Validate content is non-empty.
      2. Write to <dest>.tmp via Python (os.makedirs + open).
      3. Atomic rename: os.replace(<dest>.tmp, <dest>).
      4. On any error: clean up .tmp, emit writeCompleted(false, reason).

    Never leaves a corrupt destination file.
    Emits writeCompleted(ok, errorMessage) when the operation finishes.
*/
QtObject {
    id: root

    signal writeCompleted(bool ok, string errorMessage)

    readonly property string _script: [
        "import sys, os",
        "dest, content = sys.argv[1], sys.argv[2]",
        "tmp = dest + '.tmp'",
        "try:",
        "    os.makedirs(os.path.dirname(dest), exist_ok=True)",
        "    open(tmp, 'w').write(content)",
        "    os.replace(tmp, dest)",
        "except Exception as e:",
        "    try: os.unlink(tmp)",
        "    except: pass",
        "    print(str(e), file=sys.stderr)",
        "    sys.exit(1)"
    ].join("\n")

    property Component _writerComponent: Component {
        Process {
            id: _proc
            property string _errBuf: ""

            stderr: SplitParser {
                onRead: function(line) { _proc._errBuf += line + "\n" }
            }

            onExited: function(exitCode) {
                root.writeCompleted(exitCode === 0, exitCode === 0 ? "" : _proc._errBuf.trim())
                destroy()
            }
        }
    }

    function write(path, content) {
        if (!content || content.length === 0) {
            writeCompleted(false, "FileWriter: content must not be empty")
            return
        }
        _writerComponent.createObject(root, {
            command: ["python3", "-c", _script, path, content],
            running: true
        })
    }
}
