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
    "$HOME/Documents" "$HOME/Documents/playgrounds" "$HOME/Desktop"
)
export FZF_ALT_C_COMMAND="find ${(@q)FZF_DIR_ROOTS} -type d -maxdepth 1 -mindepth 1"

[ -n "$PS1" ] && source ~/.bash_profile;

# Completions
_boxes() {
  local cmds="add rm ls put pull init setup wipe help"
  local aliases=""
  [[ -f "$HOME/.ssh/boxes/config" ]] && aliases=$(awk '/^Host / {print $2}' "$HOME/.ssh/boxes/config")

  if (( CURRENT == 2 )); then
    compadd -- ${(z)cmds} ${(z)aliases}
  else
    case "$words[2]" in
      rm|init|put|pull|setup) compadd -- ${(z)aliases} ;;
    esac
  fi
}
compdef _boxes boxes