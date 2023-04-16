# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
 source /usr/share/zsh/manjaro-zsh-prompt
fi
export IDEA_JDK=/usr/lib/jvm/jdk-jetbrains
export ANDROID_SDK_ROOT=/home/shvmpc/Android/Sdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_16=/usr/lib/jvm/java-16-openjdk
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export TESSDATA_PREFIX=/usr/local/share/tessdata/
export PATH=$PATH:$JAVA_HOME:$ANDROID_SDK_ROOT:$IDEA_JDK:$GEM_HOME/bin:$TESSDATA_PREFIX
#export STARSHIP_CONFIG=/mnt/forlinuxuse/Downloads/pastel-powerline.toml
#export PATH="$PATH:$STARSHIP_CONFIG"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

LANG=en_US.UTF-8
LANGUAGE=en
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC=en_IN.UTF-8
LC_TIME=en_IN.UTF-8
LC_COLLATE="en_US.UTF-8"
LC_MONETARY=en_IN.UTF-8
LC_MESSAGES="en_US.UTF-8"
LC_PAPER=en_IN.UTF-8
LC_NAME=en_IN.UTF-8
LC_ADDRESS=en_IN.UTF-8
LC_TELEPHONE=en_IN.UTF-8
LC_MEASUREMENT=en_IN.UTF-8
LC_IDENTIFICATION=en_IN.UTF-8
LC_ALL=

#starship config
eval "$(starship init zsh)"

alias plis="sudo "
alias install="pacman -Sy"
alias remove="pacman -Rns"
alias -s txt=vim
#clear && cat /home/shvmpc/.cache/wal/sequences
alias nano=vim
alias ll="ls -l"
alias vim=nvim
alias vi=nvim
alias hc=herbstclient
alias ...="cd ../.."

export EDITOR=/usr/bin/vim
export CONF=~/.config
export FLU=/mnt/forlinuxuse
export STF=/run/media/shvmpc/Stuff

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
