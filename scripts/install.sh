#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

# Create temporary directory in HOME
export HYPRPHARCH_TEMP="$HOME/.cache/hyprpharch-install-$$"
mkdir -p "$HYPRPHARCH_TEMP"

# Cleanup on exit
trap "rm -rf '$HYPRPHARCH_TEMP'" EXIT INT TERM

# Update system
update_system() {
    print_message "Updating system..."
    sudo pacman -Syu --noconfirm
}

# Install paru
install_paru() {
    bash "$SCRIPT_DIR/install-paru.sh"
}

# Essential installation - All base packages
install_essential() {
    print_message "Installing essential packages..."
    sudo pacman -S --needed --noconfirm base linux linux-headers sudo git wget tree iwd smartmontools libreoffice-fresh dosfstools networkmanager network-manager-applet bluez bluez-utils bluetui pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber qt5-wayland qt6-wayland python-gobject noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols hyprland hypridle hyprlock hyprpicker hyprshot swww uwsm quickshell xdg-desktop-portal-hyprland xdg-desktop-portal-gnome polkit-gnome dunst rofi brightnessctl grim slurp kitty ghostty zsh starship fzf lsd tmux btop fastfetch yazi nano vim neovim gtk3 gtk4 nwg-look ly firefox pavucontrol power-profiles-daemon zram-generator mpv obs-studio htop npm xorg-server xorg-xinit
    paru -S --needed --noconfirm gearlever kotofetch phinger-cursors
    print_success "Essential packages installed"
}

# Custom GTK themes
install_gtk_themes() {
    if ask "Install custom GTK themes?"; then
        print_message "Installing GTK themes..."
        bash "$SCRIPT_DIR/install-gtk.sh"
    fi
}

# Intel drivers
install_intel() {
    if ask "Install Intel drivers (GPU)?"; then
        print_message "Installing Intel drivers..."
        sudo pacman -S --needed --noconfirm intel-media-driver intel-ucode vulkan-intel lib32-vulkan-intel libva-intel-driver vulkan-tools
    fi
}

# NVIDIA drivers
install_nvidia() {
    if ask "Install NVIDIA drivers (GPU)?"; then
        print_warning "Make sure you have an NVIDIA GPU!"
        print_message "Installing NVIDIA drivers..."
        sudo pacman -S --needed --noconfirm nvidia-open-dkms lib32-nvidia-utils libva-nvidia-driver lib32-mesa
    fi
}

# Development tools
install_dev_tools() {
    if ask "Install development tools (Docker, VS Code)?"; then
        sudo pacman -S --needed --noconfirm docker docker-buildx docker-compose
        sudo usermod -aG docker "$USER"
        paru -S --needed --noconfirm visual-studio-code-bin
    fi
}

# Spotify with Spicetify
install_spotify() {
    if ask "Install Spotify with Spicetify?"; then
        bash "$SCRIPT_DIR/install-spotify.sh"
    fi
}

# Steam
install_steam() {
    if ask "Install Steam with Discord?"; then
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
            sudo pacman -Sy --noconfirm
        fi
        sudo pacman -S --needed --noconfirm steam discord
    fi
}

# Copy dotfiles
copy_dotfiles() {
    if ask "Copy configuration files (dotfiles)?"; then
        print_message "Copying dotfiles..."
        bash "$SCRIPT_DIR/install-os-config.sh"
    fi
}

# Configure Zsh
configure_zsh() {
    if ask "Configure Zsh with Oh My Zsh and plugins?"; then
        bash "$SCRIPT_DIR/configure-zsh.sh"
    fi
}


# Main installation
main_installation() {
    print_banner "HyprPharch Installer"
    echo "Essential packages will be installed automatically."
    echo "Optional components will prompt for confirmation."
    echo
    
    update_system
    install_paru
    install_essential
    
    # Optional installations
    print_message "════════════════════════════════════════"
    print_message "       OPTIONAL COMPONENTS              "
    print_message "════════════════════════════════════════"
    
    install_gtk_themes
    install_intel
    install_nvidia
    install_dev_tools
    install_spotify
    install_steam
    
    # Final configuration
    print_message "════════════════════════════════════════"
    print_message "       FINAL CONFIGURATION              "
    print_message "════════════════════════════════════════"
    copy_dotfiles
    configure_zsh
    
    echo
    print_success "╔════════════════════════════════════════╗"
    print_success "║  Installation completed!               ║"
    print_success "╚════════════════════════════════════════╝"
    print_warning "Restart your system to apply all changes"
}

main_installation