source ~/.bashrc

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export PATH="/usr/local/sbin:$PATH:/Users/skylarpayne/go/bin"

# added by Miniconda2 4.3.21 installer
export PATH="/Users/skylarpayne/miniconda2/bin:$PATH"

# added by Anaconda3 5.0.0 installer
export PATH="/Users/skylarpayne/anaconda3/bin:$PATH"

. "$HOME/.local/bin/env"
