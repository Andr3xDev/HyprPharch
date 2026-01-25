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

# Ask function
ask() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Update system
update_system() {
    print_message "Updating system..."
    sudo pacman -Syu --noconfirm
}

# Install paru
install_paru() {
    if ! command_exists paru; then
        print_message "Installing paru..."
        bash "$SCRIPT_DIR/install-paru.sh"
    fi
}

# Base packages
install_base() {
    print_message "Installing base packages..."
    sudo pacman -S --needed --noconfirm base base-devel linux linux-firmware linux-headers linux-zen linux-zen-headers efibootmgr dkms git wget nano vim neovim tree smartmontools networkmanager network-manager-applet iwd wireless_tools pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber libpulse gst-plugin-pipewire bluez bluez-utils bluetui brightnessctl grim slurp sof-firmware python-gobject qt5-wayland qt6-wayland zram-generator noto-fonts-emoji noto-fonts-cjk dosfstools bridge-utils dnsmasq sudo npm
}

# Hyprland and wayland tools
install_hyprland() {
    print_message "Installing Hyprland..."
    sudo pacman -S --needed --noconfirm hyprland hypridle hyprlock hyprpicker hyprshot dunst rofi swww xdg-desktop-portal-hyprland xdg-desktop-portal-gnome polkit-gnome polkit-kde-agent xdg-utils uwsm quickshell
}

# Terminal and shell
install_terminal() {
    print_message "Installing terminal and shell..."
    sudo pacman -S --needed --noconfirm kitty zsh starship fzf lsd btop fastfetch yazi ghostty tmux gtk4 gtk3
}

# Themes and appearance
install_themes() {
    print_message "Installing themes and fonts..."
    sudo pacman -S --needed --noconfirm nwg-look sassc ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols woff2-font-awesome
    
    # Install GTK themes
    print_message "Installing GTK themes..."
    bash "$SCRIPT_DIR/install-gtk.sh"
}

# Basic apps
install_apps() {
    print_message "Installing basic applications..."
    sudo pacman -S --needed --noconfirm firefox pavucontrol mpv power-profiles-daemon
}

# Display manager
install_display_manager() {
    print_message "Installing display manager..."
    sudo pacman -S --needed --noconfirm ly xorg-server xorg-xinit
}

# Intel drivers
install_intel() {
    if ask "Install Intel drivers?"; then
        print_message "Installing Intel drivers..."
        sudo pacman -S --needed --noconfirm intel-media-driver intel-ucode vulkan-intel lib32-vulkan-intel libva-intel-driver vulkan-tools
    fi
}

# NVIDIA drivers
install_nvidia() {
    if ask "Install NVIDIA drivers?"; then
        print_warning "Make sure you have an NVIDIA GPU!"
        print_message "Installing NVIDIA drivers..."
        sudo pacman -S --needed --noconfirm nvidia-open-dkms lib32-nvidia-utils libva-nvidia-driver
    fi
}

# Development tools
install_dev() {
    if ask "Install development tools (Docker)?"; then
        print_message "Installing development tools..."
        sudo pacman -S --needed --noconfirm docker docker-buildx docker-compose
        
        # Add user to docker group
        sudo usermod -aG docker "$USER"
        print_success "User added to docker group"
    fi
}

# Personal apps (Discord, Spotify, etc)
install_personal() {
    if ask "Install personal apps (Discord, Spotify, LibreOffice, OBS)?"; then
        print_message "Installing personal applications..."
        sudo pacman -S --needed --noconfirm discord spotify-launcher libreoffice-fresh obs-studio proton-vpn-gtk-app
        
        # AUR packages
        if command_exists paru; then
            print_message "Installing AUR personal packages..."
            paru -S --needed --noconfirm visual-studio-code-bin spicetify-cli gearlever opencode-bin
        fi
    fi
}

# Gaming (Steam)
install_gaming() {
    if ask "Install Steam?"; then
        print_message "Enabling multilib repository..."
        # Enable multilib if not already enabled
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
            sudo pacman -Sy --noconfirm
        fi
        
        print_message "Installing Steam..."
        sudo pacman -S --needed --noconfirm steam lib32-mesa
    fi
}

# AUR packages
install_aur() {
    if command_exists paru; then
        print_message "Installing AUR packages..."
        paru -S --needed --noconfirm dwarfs-bin kotofetch phinger-cursors
    fi
}

# Copy dotfiles
copy_dotfiles() {
    print_message "Copying dotfiles..."
    bash "$SCRIPT_DIR/install-os-config.sh"
}

# Enable services
enable_services() {
    print_message "Enabling system services..."
    
    # Basic services for everyone
    sudo systemctl enable NetworkManager
    sudo systemctl enable bluetooth
    
    # Ly if installed
    if pacman -Q ly &>/dev/null; then
        sudo systemctl enable --now ly@tty1.service

    fi
    
    # Docker if installed
    if pacman -Q docker &>/dev/null; then
        sudo systemctl enable docker
    fi
    
    print_success "Services enabled"
}

# Configure Zsh
configure_zsh() {
    if ask "Configure Zsh with Oh My Zsh and plugins?"; then
        bash "$SCRIPT_DIR/configure-zsh.sh"
    fi
}

# Main menu
show_menu() {
    print_banner "HyprPharch Installer"
    
    echo "Select installation mode:"
    echo
    echo "1) Full installation (with personal apps)"
    echo "2) Basic installation (minimal setup)"
    echo "3) Exit"
    echo
    read -p "Option: " option
    
    case $option in
        1)
            print_message "Starting FULL installation..."
            echo
            update_system
            install_paru
            install_base
            install_hyprland
            install_terminal
            install_themes
            install_apps
            install_display_manager
            install_intel
            install_nvidia
            install_dev
            install_personal
            install_gaming
            install_aur
            copy_dotfiles
            enable_services
            configure_zsh
            
            echo
            print_success "╔════════════════════════════════════════╗"
            print_success "║  Full installation completed!          ║"
            print_success "╚════════════════════════════════════════╝"
            print_warning "Reboot your system to apply all changes"
            ;;
        2)
            print_message "Starting BASIC installation..."
            echo
            update_system
            install_paru
            install_base
            install_hyprland
            install_terminal
            install_themes
            install_apps
            install_display_manager
            install_intel
            install_nvidia
            install_dev
            install_aur
            copy_dotfiles
            enable_services
            configure_zsh
            
            echo
            print_success "╔════════════════════════════════════════╗"
            print_success "║  Basic installation completed!         ║"
            print_success "╚════════════════════════════════════════╝"
            print_warning "Reboot your system to apply all changes"
            ;;
        3)
            exit 0
            ;;
        *)
            print_error "Invalid option"
            sleep 2
            show_menu
            ;;
    esac
}

show_menu
