# source bash rc if running bash and exists
[ -f ~/.bashrc ] && . ~/.bashrc

# set PATH so it includes user bins if exists
PATH="~/bin:$PATH"
PATH="~/.local/bin:$PATH"
PATH="~/.cargo/bin:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export GIT_PAGER="delta"

if [[ -x /usr/bin/batcat ]]; then
	export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif [[ -x ~/.local/bin/bat ]]; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

export BAT_THEME="Catppuccin Mocha"
