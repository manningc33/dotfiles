# source bash rc if running bash and exists
[ -f ~/.bashrc ] && . ~/.bashrc
  
# set PATH so it includes user  bins if exists
[ -d ~/bin ] && PATH="~/bin:$PATH"
[ -d ~/.local/bin ] && PATH="~/.local/bin:$PATH"

export EDITOR="vim"
export BAT_THEME="Catppuccin Mocha"
