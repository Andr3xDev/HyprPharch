<div align="center">
    <h1 align="center">Andr3x's Dotfiles</h1>
    <p align="center">
        My minimalist but functional Arch Linux setup with Hyprland
    </p>
</div>

</br>

## About The Project

This configuration is focused on having only the essential visual and practical elements, which are also lightweight and consume the least amount of resources. It has a sober and **minimalist style** that focuses on productivity without sacrificing a clean and calm aesthetic.

</br>

## Screenshots
- Overview:
  
![start](docs/home.png)

<details>
    <summary>Other images</summary>  

![start](docs/start.png)

![start](docs/systemApps.png)

![start](docs/menu.png)

![start](docs/nvim.png)

![start](docs/bSpotify.png)

![start](docs/close.png)

</details>


</br>

## Resume

| Categoría            | Aplicación         |
|----------------------|--------------------|
| **Compositor**      | Hyprland            |
| **Terminal**        | Kitty               |
| **Shell**           | Zsh                 |
| **Editor**          | Neovim / VScode     |
| **Notifications**   | Dunst               |
| **Menu**            | Rofi-wayland        |
| **Bar**             | Waybar              |
| **Calendar**        | Gsimplecal          |
| **Bluethoot**       | Bluetui             |
| **Network**         | nmtui               |
| **Sound control**   | Pavucontrol         |




</br>

## Getting Started
To obtain this configuration, there are two options. The first one is through a script, and the other one is manually, depending on what you want to have in your config.


> [!WARNING]
> This section is not available at the moment

### Automatic installation
This script will install all the dependencies and packages necessary to copy the complete configuration. Ideal to have an exact version of this configuration.

1. Clone the repo
   ```sh
   git clone https://github.com/Andr3xDev/dotfiles.git
   ```

2. Run the installation script
   ```sh
    cd dotfiles/script
   ./installation..sh
   ```
3. Continue the installation, completing what the script asks for

   
### Manual installation
You can copy the configurations that interest you and also see what package and dependencies you need.
1. Clone the repo.
    ```sh
    git clone https://github.com/Andr3xDev/dotfiles.git
    ```

2. Copy target config.
    ```sh
    cd Dotfiles/dots
    cp -r <Target config> ¬/.config/
    ```
   
3. Filter and install the packages you need.
    ```sh
    sudo pacman -S --noconfirm --needed hyprland hyprpaper hyprlock hypridle kitty 7zip bluetui brightnessctl btop dunst fastfetch firefox fzf gtk-engine-murrine neovim noto-fonts-cjk nwg-look papirus-icon-theme pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse polkit-gnome python python-gobject rofi-wayland spotify-launcher ttf-firacode-nerd ttf-font-awesome ttf-jetbrains-mono-nerd unzip waybar wireplumber xdg-desktop-portal-hyprland xdg-utils yazi zsh
    ```

    ```sh
    paru -S --noconfirm --needed bibata-cursor-theme-bin galendae-git spicetify-cli visual-studio-code-bin
    ```

4. (OPTIONAL), download Gruvbox Material GTK theme from the sourse, or run the script.
    ```sh
    cd dotfiles/scripts
    ./gtk.sh
    ```

</br>

## License
Distributed under the Unlicense License. See `LICENSE` for more information.
