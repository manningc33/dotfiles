# source bash rc if running bash and exists
[ -f ~/.bashrc ] && . ~/.bashrc

# set PATH so it includes user bins if exists
PATH="~/.local/bin:$PATH"
PATH="~/.cargo/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

command -v delta &>/dev/null && export GIT_PAGER="delta"
command -v bat &>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'" && export BAT_THEME="Catppuccin Mocha"
