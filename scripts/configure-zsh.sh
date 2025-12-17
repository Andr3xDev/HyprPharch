#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

REAL_USER=$(get_real_user)
USER_HOME=$(get_user_home)

check_root

print_banner "Configuring Zsh"

# Install Zsh and Starship if not present
if ! command_exists zsh; then
    pacman -S --needed --noconfirm zsh
fi

if ! command_exists starship; then
    pacman -S --needed --noconfirm starship
fi

# Install Oh My Zsh
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    print_message "Installing Oh My Zsh..."
    sudo -u "$REAL_USER" sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install plugins
print_message "Installing plugins..."
PLUGIN_DIR="$USER_HOME/.oh-my-zsh/custom/plugins"

for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
    if [ ! -d "$PLUGIN_DIR/$plugin" ]; then
        sudo -u "$REAL_USER" git clone "https://github.com/zsh-users/$plugin.git" "$PLUGIN_DIR/$plugin"
    fi
done

# Configure .zshrc
print_message "Configuring .zshrc..."
[ -f "$USER_HOME/.zshrc" ] && sudo -u "$REAL_USER" cp "$USER_HOME/.zshrc" "$USER_HOME/.zshrc.backup"

sudo -u "$REAL_USER" tee "$USER_HOME/.zshrc" > /dev/null <<'EOF'
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

# Change default shell
print_message "Changing default shell..."
chsh -s "$(which zsh)" "$REAL_USER"

print_success "Zsh configured successfully"
print_warning "Run 'exec zsh' or restart your session"