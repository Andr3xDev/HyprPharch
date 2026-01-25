#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

print_banner "Configuring Zsh"

# Install Zsh and Starship if not present
if ! command_exists zsh; then
    sudo pacman -S --needed --noconfirm zsh
fi

if ! command_exists starship; then
    sudo pacman -S --needed --noconfirm starship
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_message "Installing Oh My Zsh..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install plugins
print_message "Installing plugins..."
PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"

for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
    if [ ! -d "$PLUGIN_DIR/$plugin" ]; then
        git clone --depth 1 "https://github.com/zsh-users/$plugin.git" "$PLUGIN_DIR/$plugin"
    fi
done

# Configure .zshrc
print_message "Configuring .zshrc..."
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup"

# Copy .zshrc from repository
CUSTOM_ZSHRC="$SCRIPT_DIR/../zshrc/.zshrc"
if [ -f "$CUSTOM_ZSHRC" ]; then
    print_message "Using .zshrc from repository..."
    cp "$CUSTOM_ZSHRC" "$HOME/.zshrc"
else
    print_warning ".zshrc not found in repository, creating default..."
    tee "$HOME/.zshrc" > /dev/null <<'EOF'
export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'

HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY
EOF
fi

# Change default shell
print_message "Changing default shell..."
chsh -s "/bin/zsh"

print_success "Zsh configured successfully"
print_warning "Run 'exec zsh' or restart your session"