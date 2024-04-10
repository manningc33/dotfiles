#!/usr/bin/env bash

# Easier navigation:
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd../../../.."
alias home="cd ~"
alias cd..="cd .."
alias dots="cd ~/dotfiles/"

# some more ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF":

# Utility functions
alias h="history | grep"                        # grep history if ctrl-r isn't working
alias f="find . | grep"                         # grep current dir if ctrl-t isn't working
alias sudo="sudo "                              # Enable aliases to be sudo'ed
alias refresh="source ~/.bashrc"                # reload .bashrc
alias dotsinstall='cd ~/dotfiles; . ./setup.sh' # run set up for dotfiles

# shorthand
alias cls="clear"
alias v="nvim"
alias lg="lazygit"
alias g="git"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls="ls --color=auto"
	# alias dir="dir --color=auto"
	# alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

# forcing certain programs
alias cat='bat --color=always'
alias rcat='cat' # rcat = raw cat
alias vim="nvim"
alias rvim="vim" # rvim raw vim
alias python="python3"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
