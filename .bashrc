# Load shell dotfiles
#for file in ~/.{bash_aliases}; do 
#    [ -r "$file" ] && [ -f "$file" ] && source "$file"
#done
#unset file
[ -f ~/.bash_aliases  ] && . ~/.bash_aliases

# ==== EXPORTS ==== 
# Make vim the default editor. 
export EDITOR='vim'

# increase Bash history size 
export HISTSIZE=32768
export HISTFILESIZE=32768

# Don't put duplicate lines or lines starting with space in the history
export HISTCONTROL='erasedups:ignoreboth'
export HISTIGNORE="&:[ ]*:exit:ls:pg:fg:history:clear:h"

# force color terminal
export TERM=xterm-256color

# Case-insensitive globbing (used in pathname expansion) 
shopt -s nocaseglob

# Append the the Bash history file, rather than overwriting it 
shopt -s histappend 

# check the window size after each command and, if necessary, 
# update the value of LINES and COLUMNS. 
shopt -s checkwinsize 

# Enable some Bash 4 features when possible: 
# * autocd, e.g. '**/qux' will enter './foo/bar/baz/qux'
# * Recursize globbing, e.g. 'echo **/*.text' 
# * dirspell, correct spelling errors during tab-completion 
# * cdspell correct spelling errors in arguments supplied to cd 
for option in autocd globstar dirspell cdspell; do
    shopt -s "$option" 2> /dev/null
done

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set prompt just incase starship isn't avaliable
PS1="\n\t \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\]\n\\$ "

# set starship prompt:
[ -f /usr/local/bin/starship ] && eval "$(starship init bash)"
