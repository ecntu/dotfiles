# Exports
export TERM='xterm-256color'
export EDITOR='vim'
export GOPATH=$HOME/go

# Path add exports
export PATH="$HOME/bin:$PATH"; # Add `~/bin`
export PATH=$PATH:~/Library/Python/3.9/bin # python bin (jupyter etc) on mac
export PATH=$PATH:$GOPATH/bin

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;