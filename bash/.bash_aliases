#!/usr/bin/env bash

# use zoxide instead of cd
if command -v zoxide &>/dev/null; then
	alias cd="z"
	alias rcd="\cd"
fi

# use eza instead of ls
if command -v eza &>/dev/null; then
	alias ls="eza"
	alias ll="eza -aghl"
	alias eza="eza --icons"
	alias rls="\ls --color=auto"
	alias rll="\ls -AlF --color=auto"
else
	# some more ls aliases
	alias ll="ls -AlF"
	alias la="ls -A"
	alias l="ls -CF":
	alias ls="ls --color=auto"
fi

# use bat instead of cat
if command -v bat &>/dev/null; then
	alias cat='bat --color=always'
	alias rcat='\cat' # rcat = raw cat
fi

alias v="nvim"
alias v.="v ."
alias vi="nvim"
alias vim="nvim"
alias rvi="\vi"
alias rvim="\vim" # rvim raw vim
alias python="python3"

# Easier navigation:
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd../../../.."
alias home="cd ~"
alias cd..="cd .."
alias dots="cd ~/dotfiles/"

# Utility functions
alias h="history | grep"                        # grep history if ctrl-r isn't working
alias f="find . | grep"                         # grep current dir if ctrl-t isn't working
alias sudo="sudo "                              # Enable aliases to be sudo'ed
alias refresh="source ~/.bashrc"                # reload .bashrc
alias dotsinstall='cd ~/dotfiles; . ./setup.sh' # run set up for dotfiles

# shorthand
alias cls="clear"
alias lg="lazygit"
alias g="git"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	# alias dir="dir --color=auto"
	# alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
