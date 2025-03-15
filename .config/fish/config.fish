if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Hide welcome message
set fish_greeting

# Aliases 
alias n=nemo
alias plis="sudo"
alias hc="herbstclient"
alias dir="dir --color=auto"
alias tata="exit"
alias dots="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias font-list="fc-list : family | awk -F',' '{print $1}' | sort | uniq | fzf | tr -d '\n'"
alias hcs="history clear-session"
alias rrr="ranger"
alias xcc="xclip -selection clipboard"
alias rl="readlink -f"
alias jctl="journalctl -p 3 -xb"
alias ss="import png:- | xclip -selection clipboard -t image/png"

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Abbreviations
abbr !yt "/mnt/forlinuxuse/Appimage/yt-dlp_linux"
abbr !gf "git fetch"
abbr !gl "git log | bat"
abbr !gch "git checkout"
abbr !gsw "git switch"
abbr !gc "git clone"
abbr !gs "git status"
abbr !gsl "git stash list"
abbr !gbl "git branch --list"
abbr !gfgc "git fetch && git checkout "
abbr !gswm "git switch master"
abbr !gswd "git switch release/s154-demo"
abbr !gp "git pull"
abbr !gpm "git pull && git merge"
abbr !gfgc "git fetch && git checkout"
abbr !gfc "git fetch &&"
abbr !gstp "git stash pop"
abbr !gst "git stash"
abbr !ef "nvim ~/.config/fish/config.fish"
abbr !ek "nvim ~/.config/kitty/kitty.conf"
abbr !axel "axel -n 5"

# Countdown
alias countdown="~/.config/scripts/countdown.sh"

# Paste workaround for android emulator
alias adbpaste="adb shell input text "'$(xclip -selection c -o)'""

# Directories
set local $HOME/.local
set lscripts $HOME/.local/share/nemo/scripts/
set scripts $HOME/.config/scripts/
set pbdir $HOME/.local/lib/python3.10/site-packages/pbincli/cli.py
set hcdir $HOME/.config/herbstluftwm/
set walls /run/media/shvmpc/forlinuxuse/Wallpapers/
set conf $HOME/.config
#set flu /mnt/forlinuxuse
set flu /run/media/shvmpc/forlinuxuse
set stf /run/media/shvmpc/Stuff
set doc $HOME/Documents/
set mus $HOME/Music/
set down $HOME/Downloads/
set tmp /tmp/

# ENV
set QT_QPA_PLATFORMTHEME qt5ct
# set QT_STYLE_OVERRIDE Adwaita-dark

# PATH
export PATH="$PATH:$HOME/.local/bin"
export TERM=kitty
# export QT_STYLE_OVERRIDE=Adwaita-dark

set EDITOR /bin/nvim

# Keybind
bind \cH backward-kill-word # Control-Backspace deletes backword word
bind \e\[3\;3~ kill-word # Alt-Delete deletes forward word
bind \e\[3\;5~ kill-word # Control-Delete deletes forward word
bind \eg "git status"

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'

# PrivateBin
function pbin
    python3 $pbdir send -q -s "https://0.0g.gg" -E "5min" -f $argv[1] 
end

# Backup
function backup --argument filename
    cp $filename "$filename.$(date +%d-%b-%s).bak"
end

# Pacman Related
abbr upgrade "sudo pacman -Syuu"
abbr remove "sudo pacman -Rns"
abbr install "sudo pacman -S"
abbr search "pacman -Ss"
abbr query "pacman -Qi"
abbr fixpacman "sudo rm /var/lib/pacman/db.lck"
#abbr install "sudo dnf install "

set OS $(cat /etc/os-release | grep "ID=" -m 1 | cut -d'=' -f 2)

#function install --argument program
#	if [ "$OS" = "fedora" ]
#		sudo dnf install $program
#	else if [ "$OS" = "arch" ]
#		sudo pacman -S $program
#	end
#end
#
#function upgrade 
#  if [ $OS = "fedora" ]
#    sudo dnf upgrade
#  else if [ $OS = "arch" ]
#    sudo pacman -Syuu
#  end
#end

# Adb connect
set seq1 (seq 200 -1 190)
set seq2 (seq 33 254)
set seq3 (seq 254 -1 33)
set seq3 1

function adbc
	for ip in $seq2
		echo "Trying to connect to device at 192.168.$seq3.$ip..."
		adb connect 192.168.$seq3.$ip | grep "connected"
    if [ $status -eq 0 ]
      break
		end
	end 
end

# Adb disconnect
function adbd
	for ip in $seq2
    echo "Trying to connect to device at 192.168.$seq3.$ip..."
		adb disconnect 192.168.$seq3.$ip | grep "disconnected"
    if [ $status -eq 0 ]
      break
		end
	end 
end

# Give random digit
function give_rand --argument digit
	set random_number ""
	for i in (seq $digit)
		set random_number $random_number(math (random 0 9))
	end
	echo $random_number | xclip -selection clipboard
end

# Null pointer
function 0x0 --argument filename
	curl -F"file=@$filename" -Fexpires=1 https://0x0.st
end

# Separate and merge (Split pdf)
function sepmerge --argument f l i o --description "Function to separate pdf files. "
	if test -z $f
		echo "sepmerge <first_page> <last_page> <input> <output>"
		return
	end 
	pdfseparate -f $f -l $l $i page_%d.pdf
	pdfunite page_*.pdf $o.pdf
	rm page_*.pdf
end

# Copy file to destination path, create directories if don't exist
function mkcp --argument source dest
	if path is $dest
		cp $source $dest
	else
		mkdir -p "$(path dirname $dest)" && cp -R $source $dest
	end
end

# Record monitor with system sound
function record --argument screen
	switch $screen
		case first
      #ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -y -f x11grab -s 1920x1080 -i "$DISPLAY".0 "/tmp/video-$(date +%d-%b-%s).mp4"
			ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -y -f x11grab -s 1920x1080 -i "$DISPLAY".0+1366 "/tmp/video-$(date +%d-%b-%s).mp4"
		case second
      #ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -y -f x11grab -s 1366x768 -i "$DISPLAY".0+1920 "/tmp/video-$(date +%d-%b-%s).mp4"
			ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -y -f x11grab -s 1366x768 -i "$DISPLAY".0 "/tmp/video-$(date +%d-%b-%s).mp4"
    case portion
      set selection (string split ' ' (slop -f "%x %y %w %h"))
      set X $selection[1]
      set Y $selection[2]
      set WIDTH $selection[3]
      set HEIGHT $selection[4]
      ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -y -f x11grab -s {$WIDTH}x{$HEIGHT} -i "$DISPLAY".0+{$X},{$Y} "/tmp/video-$(date +%d-%b-%s).mp4"
    case '*'
			echo "record <first|second|portion>"
	end
end

# Run with awesome
function awm
	awesome-client "awful = require(\"awful\") awful.spawn(\"$argv\")"
end

# Install aur packages
function aur-install --description "aur-install <link or package-name>"
	set pref "https://aur.archlinux.org/"
	set suff ".git"
	set link "$argv"
	switch (echo $argv)
		case "*.git"
			set folder "$(basename -s .git $argv)"
		case '*'
			set folder "$argv"
			set link "$pref""$argv""$suff"
	end
	cd /tmp && git clone "$link" && cd $folder && makepkg -si
end

# SSH
fish_ssh_agent
# Add All keys to session
for key in (dir -1 $HOME/.ssh/id_* | grep -v .pub);
  DISPLAY=1 SSH_ASKPASS="$HOME/.ssh/pass.sh" ssh-add $key < /dev/null > /dev/null 2>&1;
end

# Zoxide
zoxide init fish | source

# Clipboard
abbr to_clip "xclip -selection clipboard"

#function nvim
#    kitty @ set-spacing padding=0 && /usr/bin/nvim $argv && kitty @ set-spacing padding=20
#end

# Open directory in neovim
function vcd
  set original_dir (pwd)
  set given_path (dirname $argv[1])
  cd $given_path
  nvim $argv[1]
  cd $original_dir
end

# Type the clipboard
function pp
    sleep 0.5
    xdotool type (xclip -o -selection clipboard)
end

# VPN
function random_openvpn
    # Get a random file from the ~/.config/openvpn/ directory
    set config_file (dir ~/.config/openvpn/*.ovpn | shuf -n 1)

    # Check if a config file was found
    if test -n "$config_file"
        echo "Starting OpenVPN with config: $config_file"
        sudo openvpn --config "$config_file" --auth-user-pass $conf/openvpn/user_and_pass.txt
    else
        echo "No OpenVPN configuration files found."
    end
end

