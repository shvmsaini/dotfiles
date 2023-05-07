if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Hide welcome message
set fish_greeting

## Aliases 
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

# Directories
set scripts $HOME/.config/scripts/
set pbdir $HOME/.local/lib/python3.10/site-packages/pbincli/cli.py
set hcdir $HOME/.config/herbstluftwm/
set conf ~/.config
set FLU /mnt/forlinuxuse
set STF /run/media/shvmpc/Stuff
set QT_QPA_PLATFORMTHEME qt5ct

set EDITOR /bin/vim

# Keybind
bind \cH backward-kill-word # Control-Backspace deletes word

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'

# Common Use
alias fixpacman="sudo rm /var/lib/pacman/db.lck"

# PrivateBin
function pbin
    python3 $pbdir send -q -s "https://0.0g.gg" -E "5min" -f $argv[1] 
end

# Backup
function backup --argument filename
    cp $filename $filename.bak
end
