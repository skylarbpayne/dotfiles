export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h: \[\033[1;31m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
alias vim='nvim'
export EDITOR='/usr/local/bin/mvim -v'
export PATH="$PATH:$HOME/bin"
export GOPATH="$HOME/go"

. "$HOME/.local/bin/env"
