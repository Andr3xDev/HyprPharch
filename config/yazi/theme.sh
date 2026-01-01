#!/bin/bash

THEME_FILE="$HOME/.config/yazi/theme.toml"

case "$1" in
    gruvbox-material-d)
        cat > "$THEME_FILE" << 'EOF'
[flavor]
dark = "gruvbox-material-d"
EOF
        ;;
    gruvbox-material-l)
        cat > "$THEME_FILE" << 'EOF'
[flavor]
light = "gruvbox-material-l"
EOF
        ;;
    rose-pine-d)
        cat > "$THEME_FILE" << 'EOF'
[flavor]
dark = "rose-pine-d"
EOF
        ;;
    rose-pine-l)
        cat > "$THEME_FILE" << 'EOF'
[flavor]
light = "rose-pine-l"
EOF
        ;;
esac
