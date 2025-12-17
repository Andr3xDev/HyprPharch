#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" || { echo "Error: common.sh not found"; exit 1; }

REAL_USER=$(get_real_user)
USER_HOME=$(get_user_home)

check_root

# Ask function
ask() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Update system
update_system() {
    print_message "Updating system..."
    pacman -Syu --noconfirm
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
    pacman -S --needed --noconfirm \
        base base-devel linux linux-firmware linux-headers \
        efibootmgr dkms \
        git git-lfs wget curl \
        nano vim neovim \
        unzip zip 7zip tree \
        smartmontools \
        networkmanager network-manager-applet iwd wireless_tools \
        pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
        libpulse gst-plugin-pipewire \
        bluez bluez-utils bluetui \
        brightnessctl grim slurp \
        sof-firmware \
        python-gobject \
        qt5-wayland qt6-wayland \
        zram-generator \
        noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-liberation
}

# Hyprland and wayland tools
install_hyprland() {
    print_message "Installing Hyprland..."
    pacman -S --needed --noconfirm \
        hyprland hypridle hyprlock hyprpicker hyprshot hyprpaper \
        xdg-desktop-portal-hyprland \
        dunst rofi swww \
        wl-clipboard cliphist \
        polkit-gnome \
        xdg-utils \
        uwsm
}

# Terminal and shell
install_terminal() {
    print_message "Installing terminal and shell..."
    pacman -S --needed --noconfirm \
        kitty zsh starship \
        fzf lsd btop htop \
        fastfetch yazi \
        ripgrep fd bat eza
}

# Themes and appearance
install_themes() {
    print_message "Installing themes and fonts..."
    pacman -S --needed --noconfirm \
        nwg-look nwg-displays \
        papirus-icon-theme \
        xsettingsd sassc \
        ttf-firacode-nerd ttf-jetbrains-mono-nerd \
        woff2-font-awesome \
        gtk-engine-murrine
    
    # Install GTK themes as user
    print_message "Installing GTK themes..."
    sudo -u "$REAL_USER" bash "$SCRIPT_DIR/install-gtk.sh"
}

# Basic apps
install_apps() {
    print_message "Installing basic applications..."
    pacman -S --needed --noconfirm \
        firefox \
        thunar thunar-archive-plugin thunar-volman \
        file-roller \
        pavucontrol \
        mpv \
        imv \
        power-profiles-daemon
}

# Display manager
install_display_manager() {
    print_message "Installing display manager..."
    pacman -S --needed --noconfirm \
        ly \
        xorg-server xorg-xinit
}

# Intel drivers
install_intel() {
    if ask "Install Intel drivers?"; then
        print_message "Installing Intel drivers..."
        pacman -S --needed --noconfirm \
            intel-media-driver \
            intel-ucode \
            vulkan-intel \
            mesa mesa-utils \
            libva-intel-driver
    fi
}

# NVIDIA drivers
install_nvidia() {
    if ask "Install NVIDIA drivers?"; then
        print_warning "Make sure you have an NVIDIA GPU!"
        print_message "Installing NVIDIA drivers..."
        pacman -S --needed --noconfirm \
            nvidia nvidia-utils nvidia-settings \
            nvidia-prime \
            lib32-nvidia-utils \
            libva-nvidia-driver
    fi
}

# Development tools
install_dev() {
    if ask "Install development tools (Docker, npm, etc)?"; then
        print_message "Installing development tools..."
        pacman -S --needed --noconfirm \
            docker docker-compose \
            npm nodejs \
            python python-pip
        
        # Add user to docker group
        usermod -aG docker "$REAL_USER"
        print_success "User added to docker group"
    fi
}

# Personal apps (Discord, Spotify, etc)
install_personal() {
    if ask "Install personal apps (Discord, Spotify, LibreOffice, OBS)?"; then
        print_message "Installing personal applications..."
        pacman -S --needed --noconfirm \
            discord \
            spotify-launcher \
            libreoffice-still \
            obs-studio \
            proton-vpn-gtk-app \
            gimp \
            vlc
        
        # AUR packages
        if command_exists paru; then
            print_message "Installing AUR personal packages..."
            sudo -u "$REAL_USER" paru -S --needed --noconfirm \
                visual-studio-code-bin \
                spicetify-cli \
                gearlever || true
        fi
    fi
}

# Gaming (Steam)
install_gaming() {
    if ask "Install Steam?"; then
        print_message "Installing Steam..."
        pacman -S --needed --noconfirm steam
    fi
}

# AUR packages
install_aur() {
    if command_exists paru; then
        print_message "Installing AUR packages..."
        sudo -u "$REAL_USER" paru -S --needed --noconfirm \
            bibata-cursor-theme-bin \
            phinger-cursors \
            quickshell-git \
            kotofetch || true
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
    systemctl enable NetworkManager
    systemctl enable bluetooth
    systemctl enable ly
    
    # Docker if installed
    if pacman -Q docker &>/dev/null; then
        systemctl enable docker
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
