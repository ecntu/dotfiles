# Exports
export TERM='xterm-256color'
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR='vim'
export GOPATH=$HOME/go

# Path add exports
export PATH="$HOME/bin:$PATH"; # Add `~/bin`
export PATH="$PATH:$HOME/.local/bin" # Add `~/.local/bin/env` (uv)
export PATH=$PATH:$GOPATH/bin

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;