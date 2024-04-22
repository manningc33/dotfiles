# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
export TMUX_PLUGIN_MANAGER_PATH=~/.local/share/tmux/plugins

# Prevent file overwriet on stdout redirection
# Use '>|' to force redirection to an existing file
set -o noclobber

# enable shell options
options=(
	autocd       # e.g. '**/qux' will enter './foo/bar/baz/qux'
	cdspell      # correct spelling errors in arguments supplied to cd
	checkwinsize # check the window size after each command and, if necessary, update the value of LINES and COLUMNS.
	cmdhist      # save multiline commands in one history entry
	dirspell     # correct spelling errors during tab-completion
	globstar     # recursive globbing, e.g. 'echo **/*.text'
	histappend   # append the the Bash history file, rather than overwriting it
	nocaseglob   # case-insensitive globbing (used in pathname expansion)
)
shopt -s "${options[@]}" # 2>/dev/null

parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set prompt just incase starship isn't available
PS1="\n\t \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\]\n\\$ "

# init fzf, starship and zoxide
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v starship &>/dev/null && eval "$(starship init bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Load shell dotfiles
#for file in ~/.{bash_aliases}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file"
#done
#unset file
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions
