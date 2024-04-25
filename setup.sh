#!/usr/bin/env bash

dotfiles_dir=~/dotfiles

git pull origin master

function homebrewInstall() {
	! command -v brew &>/dev/null && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew upgrade

	pkgs=(
		bat
		eza
		fzf
		git
		git-delta
		lazygit
		neofetch
		neovim
		ripgrep
		starship
		stow
		tmux
		wget
		zoxide
	)

	brew install "${pkgs[@]}"
}

function catppuccinThemesInstall() {
	# get bat catppuccin theme
	echo "Getting bat and delta catppuccin themes if not present..."
	[ ! -f ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme ] && wget -P ~/.config/bat/themes https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
	[ ! -f ~/.local/share/catppuccin/delta/catppuccin.gitconfig ] && wget -P ~/.local/share/catppuccin/delta https://github.com/catppuccin/delta/raw/main/catppuccin.gitconfig
}

function stowCreateLinks() {
	mkdir -p "$HOME/.config"
	# stowing all modules
	stow_modules=(
		bash
		git
		nvim
		starship
		tmux
		# other
	)

	stow "${stow_modules[@]}"

	. ~/.profile
	. ~/.bashrc
}

function runSetup() {
	homebrewInstall
	catppuccinThemesInstall
	stowCreateLinks
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	runSetup
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		runSetup
	fi
fi

echo "Dotfiles setup finish"

unset runSetup
unset homebrewInstall
unset catppuccinThemesInstall
unset stowCreateLinks
