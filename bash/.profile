# set PATH so it includes user bins if exists
PATH="~/.local/bin:$PATH"
PATH="~/.cargo/bin:$PATH"

if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

command -v delta &>/dev/null && export GIT_PAGER="delta"
command -v bat &>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'" && export BAT_THEME="Catppuccin Mocha"

export XDG_CONFIG_HOME="$HOME/.config"
