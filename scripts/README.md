# Installation Scripts

These scripts automate the installation of the HyprPharch dotfiles on Arch Linux.

## Quick Start

```bash
cd HyprPharch/scripts
sudo ./install.sh
```

## Scripts Overview

### `install.sh` (Main Script)

The main installation script with two modes:

**1. Full Installation** - Complete setup with personal apps

-   All base packages and dependencies
-   Hyprland and Wayland tools
-   Terminal (Kitty) and Shell (Zsh)
-   GTK themes (Gruvbox, Rose Pine)
-   Basic apps (Firefox, Thunar, etc.)
-   Personal apps (Discord, Spotify, LibreOffice, OBS, VSCode)
-   Gaming (Steam)
-   Docker and development tools (optional)
-   Dotfiles and configurations
-   Services enabled

**2. Basic Installation** - Minimal setup

-   All base packages
-   Hyprland environment
-   Terminal and shell
-   Themes and fonts
-   Basic applications
-   Dotfiles and configurations
-   Optional: drivers, dev tools

### Other Scripts

-   **`common.sh`** - Shared functions and colors
-   **`install-paru.sh`** - Install Paru AUR helper
-   **`configure-zsh.sh`** - Configure Zsh with Oh My Zsh and plugins
-   **`install-gtk.sh`** - Install GTK themes (Gruvbox, Rose Pine)
-   **`install-os-config.sh`** - Copy dotfiles to ~/.config

## What Gets Installed

### Base System

-   Linux kernel and headers
-   Base development tools (base-devel)
-   Network tools (NetworkManager, iwd)
-   Audio (PipeWire)
-   Bluetooth
-   System utilities

### Hyprland Environment

-   Hyprland compositor
-   Hypridle, Hyprlock, Hyprpicker, Hyprshot, Hyprpaper
-   Dunst (notifications)
-   Rofi (launcher)
-   SWWW (wallpaper)
-   QuickShell (bar)
-   Polkit

### Terminal & Shell

-   Kitty terminal
-   Zsh shell
-   Oh My Zsh
-   Starship prompt
-   Plugins: syntax-highlighting, autosuggestions
-   CLI tools: fzf, lsd, btop, fastfetch, yazi, ripgrep, fd, bat

### Themes

-   GTK themes: Gruvbox Material, Rose Pine
-   Icon theme: Papirus
-   Cursor themes: Bibata, Phinger
-   Fonts: FiraCode Nerd, JetBrains Mono Nerd, Font Awesome

### Applications

**Basic:**

-   Firefox
-   Thunar file manager
-   MPV player
-   Pavucontrol (audio)

**Personal (Full Install):**

-   Discord
-   Spotify
-   LibreOffice
-   OBS Studio
-   Visual Studio Code
-   GIMP
-   VLC

### Configurations

All config files from `config/` are copied to `~/.config/`:

-   hypr (Hyprland config)
-   kitty
-   dunst
-   rofi
-   nvim
-   quickshell
-   btop, fastfetch, yazi
-   And more...

### Services Enabled

-   NetworkManager
-   Bluetooth
-   Ly (display manager)
-   Docker (if installed)

## Post-Installation

After installation completes:

1. **Reboot your system**

    ```bash
    sudo reboot
    ```

2. **Login through Ly display manager**

3. **Select Hyprland as your session**

4. **Activate Zsh** (if configured)
    ```bash
    exec zsh
    ```

## Manual Installation

You can run individual scripts if needed:

```bash
# Install only Paru
sudo ./install-paru.sh

# Configure only Zsh
sudo ./configure-zsh.sh

# Install only GTK themes
./install-gtk.sh

# Copy only dotfiles
sudo ./install-os-config.sh
```

## Requirements

-   Fresh Arch Linux installation
-   Internet connection
-   Root/sudo access

## Notes

-   The script will ask for confirmation before installing optional components
-   Existing configs are backed up to `~/.config.backup-[timestamp]`
-   All scripts are in English
-   Compatible with most hardware configurations
