if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Hide welcome message
set fish_greeting

# Aliases 
alias hc="herbstclient"
# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.='exa -ald --color=always --group-directories-first --icons .*' # show only dotfiles
alias dir="dir --color=auto"
alias tata="exit"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias dots="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias font-list="fc-list : family | awk -F',' '{print $1}' | sort | uniq | fzf | tr -d '\n'"
alias hcs="history clear-session"

# Directories
set scripts $HOME/.config/scripts/
set pbdir $HOME/.local/lib/python3.10/site-packages/pbincli/cli.py
set hcdir $HOME/.config/herbstluftwm/
set walls /mnt/forlinuxuse/Wallpapers/
set conf $HOME/.config
set FLU /mnt/forlinuxuse
set STF /run/media/shvmpc/Stuff
set QT_QPA_PLATFORMTHEME qt5ct
set QT_STYLE_OVERRIDE Adwaita-dark

# PATH
export PATH="$PATH:$HOME/.local/bin"
export TERM=kitty
export QT_STYLE_OVERRIDE=Adwaita-dark

set EDITOR /bin/vim

# Keybind
bind \cH backward-kill-word # Control-Backspace deletes word

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'

# PrivateBin
function pbin
    python3 $pbdir send -q -s "https://0.0g.gg" -E "5min" -f $argv[1] 
end

# Backup
function backup --argument filename
    cp $filename "$filename-$(date -I).bak"
end

# Pacman Related
alias upgrade="sudo pacman -Syuu"
alias remove="sudo pacman -Rns "
alias install="sudo pacman -S "
alias search="pacman -Ss"
alias query="pacman -Qi"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"

# Null pointer
function 0x0 --argument filename
	curl -F"file=@$filename" -Fexpires=1 https://0x0.st
end

# Separate and merge
function sepmerge --argument f l i o
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
