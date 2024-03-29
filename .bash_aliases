#!/usr/bin/env bash

# Easier navigation: 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd../../../.."
alias home="cd ~"
alias cd..="cd .."

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

# some more ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# use pygmentize to do colored print
alias ccat="pygmentize -g"

# grep history 
alias h="history | grep"

# grep current folder 
alias f="find . | grep"

# python alias 
alias python="python3"

# Enable aliases to be sudo'ed 
alias sudo="sudo "

# refersh bash
alias refresh="source ~/.bashrc"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

