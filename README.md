# Personal dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Requires `stow`, `zsh`, `fzf`, and [oh-my-zsh](https://ohmyz.sh/).

## What's inside

- **home/** — shell config (zsh, bash, aliases, functions), gitconfig, gitignore
- **vim/** — .vimrc
- **tmux/** — .tmux.conf
- **custom_bins/** — scripts in `~/.local/bin` (boxes, tmpjn, rmvenvs)

## Install

```bash
git clone https://github.com/ecntu/dotfiles.git ~/dotfiles && cd ~/dotfiles && bash install.sh
```