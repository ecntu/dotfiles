# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(fzf history-substring-search)
source $ZSH/oh-my-zsh.sh

# FZF cd-widget config
bindkey -r '^[c'
bindkey '^f' fzf-cd-widget
FZF_DIR_ROOTS=(
    .
    "$HOME"
    "$HOME/Documents" "$HOME/Documents/playgrounds"
)
export FZF_ALT_C_COMMAND="find ${(@q)FZF_DIR_ROOTS} -type d -maxdepth 1 -mindepth 1"

[ -n "$PS1" ] && source ~/.bash_profile;