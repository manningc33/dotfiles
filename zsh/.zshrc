# history setup
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.bash_aliases

alias reload="source ~/.config/zsh/.zshrc"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
# Add Python user bin directory to PATH
# export PATH=$PATH:$(python3 -m site --user-base)/bin

