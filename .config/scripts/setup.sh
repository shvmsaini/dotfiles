#! /bin/bash

### Backup of my setup ###

# Pywal
ln -s ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
ln -s ~/.cache/wal/flameshot.ini ~/.config/flameshot/flameshot.ini

# Symlinks
ln -s /usr/bin/nvim /usr/bin/vim
ln -s /run/media/shvmpc/Stuff/Songs/ $HOME/

# All programs I need 
# VLC for codecs
sudo pacman -Syu ranger firefox neovim kitty flameshot htop picom vlc nemo

# Ranger dependencies
sudo pacman -Syu ueberzug highlight

# Theming and Fonts
sudo pacman -Syu papirus-icon-theme noto-fonts noto-fonts-emoji sddm python-pywal

# Other Stuff
sudo pacman -Syu tor torbrowser-launcher 
# For audio
sudo pacman -Syu pulseaudio alsa-utils
