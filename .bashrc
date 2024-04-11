# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable fzf (this replaces needing ~/.fzf.bash in home directory
if [[ ! "$PATH" == *~/.local/share/fzf/bin* ]]; then
	PATH="${PATH:+${PATH}:}~/.local/share/fzf/bin"
fi

# load fzf completion and keybinding function
[ -f ~/.local/share/fzf/shell/completion.bash ] && . "~/.local/share/fzf/shell/completion.bash" 2>/dev/null
[ -f ~/.local/share/fzf/shell/key-bindings.bash ] && . ~/.local/share/fzf/shell/key-bindings.bash

# ==== EXPORTS ====
# increase Bash history size
export HISTSIZE=32768
export HISTFILESIZE=32768

# Don't put duplicate lines or lines starting with space in the history
export HISTCONTROL='erasedups:ignoreboth'
export HISTIGNORE="&:[ ]*:exit:ls:pg:fg:history:clear:h"

# force color terminal
export TERM=xterm-256color

# Configure FZF
export FZF_DEFAULT_OPTS="--layout=reverse --bind ctrl-c:clear-query"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_TMUX_OPTS="-p -h 100% -w 100%"
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range=:500 {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

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
	shopt -s "$option" 2>/dev/null
done

parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set prompt just incase starship isn't avaliable
PS1="\n\t \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\]\n\\$ "

# set starship prompt:
[ "$(which starship)" != "" ] && eval "$(starship init bash)"
[ "$(which zoxide)" != "" ] && eval "$(zoxide init bash)"

# Load shell dotfiles
#for file in ~/.{bash_aliases}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file"
#done
#unset file
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions
