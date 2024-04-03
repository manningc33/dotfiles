#!/usr/bin/env bash

# search with fzf and edit
alias v="find . -not -iwholename '*.git*' | fzf-tmux -p | xargs -o vim"
alias pf="fzf-tmux ${FZF_CTRL_T_OPTS}"

# Easier navigation: 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd../../../.."
alias home="cd ~"
alias cd..="cd .."
alias dots="cd ~/dotfiles/"

# clear screen
alias cls="clear"

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
if [ -x /usr/bin/batcat ]; then 
    alias cat='batcat --color=always'
    alias rcat='cat'
fi

# grep history and current folder
alias h="history | grep" 
alias f="find . | grep"

# python alias 
alias python="python3"

# Enable aliases to be sudo'ed 
alias sudo="sudo "

# refersh bash
alias refresh="source ~/.bashrc"

# run set up for dotfiles 
alias dotsinstall='cd ~/dotfiles; . ./setup.sh'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

