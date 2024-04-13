#!/usr/bin/env bash

dotfiles_dir=~/dotfiles

git pull origin master

function createLinks() {
	# install fzf
	echo ""
	if [ ! -f /.local/share/fzf ]; then
		echo "fzf not found. Installing fzf"
		git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.local/share/fzf" &&
			yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc
	else
		echo "fzf already found. "
	fi
	echo ""
	echo ""

	if [ ! -f /usr/local/bin/starship ]; then
		echo "Starship not found. Installing starship"
		curl -sS https://starship.rs/install.sh | sh -s -- -y
		# eval "$(starship init bash)" # sourcing .bashrc will do this
	else
		echo "Starship bin found."
	fi

	echo ""
	echo ""

	# Get bat catppuccin theme
	if [ ! -f ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme ]; then
		echo "Installing bat catppuccin theme from github..."
		wget -P ~/.config/bat/themes https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
	else
		echo "Bat catppuccin theme already installed..."
	fi

	echo ""
	echo ""

	if [ ! -f ~/.local/share/catppuccin/delta/catppuccin.gitconfig ]; then
		echo "Install delta catppucin theme from github..."
		git clone --depth 1 https://github.com/catppuccin/delta.git "${HOME}/.local/share/catppuccin/delta"
	else
		echo "Delta catppucin theme already installed..."
		echo "Running git pull to update..."
		git -C ~/.local/share/catppuccin/delta pull origin main
	fi

	echo ""
	echo ""

	if [ ! -x /usr/bin/delta ]; then
		echo "Installing delta git..."
		delta_install_dir='temp-delta-install-dir'

		wget -P $delta_install_dir https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb
		sudo dpkg -i $delta_install_dir/git-delta_0.17.0_amd64.deb
		rm -rf $delta_install_dir
	else
		echo "Delta git already installed..."
	fi

	echo ""
	echo ""

	mkdir -p "$HOME/.config"
	# stowing all modules
	stow bash
	stow git
	stow nvim
	stow starship
	stow tmux

	. ~/.bashrc
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	createLinks
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		createLinks
	fi
fi

echo "Dotfiles setup finish"

unset createLinks
