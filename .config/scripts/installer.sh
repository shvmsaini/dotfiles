#! /bin/sh

# All programs
#sudo pacman -S gnome-themes-extra adwaita-qt5 adwaita-qt6 transmission-qt flameshot code htop kitty pulseaudio noto-fonts-emoji android-tools rofi qrencode zbar ntfs-3g vlc picom tesseract zenity  polkit-gnome numlockx fuse3 papirus-icon-theme ueberzug highlight gvfs nemo fzf python3 python-pip python-pywal xorg-xinit ranger bat exa git xorg neovim fish firefox pulseaudio-alsa pavucontrol gvfs-mtp
sudo pacman -Syuu picom feh zenity bat exa zoxide flameshot


# Link to Neovim
read -p "Do you want to setup symlinks as well? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo ln -s /bin/nvim /bin/vim
	sudo ln -s /bin/nvim /bin/vi
	sudo ln -s /bin/nvim /bin/nano
	sudo ln -s /bin/kitty /bin/xterm

	# Pywal
	ln -s ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
	ln -s ~/.cache/wal/flameshot.ini ~/.config/flameshot/flameshot.ini

	# Symlinks
	ln -s /usr/bin/nvim /usr/bin/vim
	ln -s /run/media/shvmpc/Stuff/Songs/ $HOME/
fi
