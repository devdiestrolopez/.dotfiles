#!/usr/bin/env bash

# Sets up this machine: symlinks the dotfiles into $HOME and installs what they depend on
# Safe to re-run. Existing files are moved to <name>.bak before linking
# Usage: ./install.sh [--no-brew]
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	if [[ -e "$2" && ! -L "$2" ]]; then
		mv "$2" "$2.bak"
		echo "Backed up $2 -> $2.bak"
	fi
	
	ln -sfn "$1" "$2"
	echo "Linked $2 -> $1"
}

link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/vim/vimrc" "$HOME/.vimrc"

mkdir -p "$HOME/.config/git"

link "$DOTFILES/git/config" "$HOME/.config/git/config"

# Make `brew` available, offering to install Homebrew if it is missing
ensure_brew() {
	local prefix
	
	for prefix in /opt/homebrew /usr/local; do
		if [[ -x "$prefix/bin/brew" ]]; then
			eval "$("$prefix/bin/brew" shellenv)"
			return 0
		fi
	done

	read -r -p "Homebrew not found. Install it now with the official installer from brew.sh? [y/N] " answer

	if [[ ! "$answer" =~ ^[Yy]$ ]]; then
		echo "Skipping Homebrew. Re-run this script after installing it"
		return 1
	fi

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
	for prefix in /opt/homebrew /usr/local; do
		[[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && return 0
	done

	echo "Homebrew install did not complete"
	return 1
}

if [[ "${1:-}" != "--no-brew" ]] && ensure_brew; then
	brew bundle --file $DOTFILES/Brewfile""
fi

terminal_profile_exists() {
	defaults export com.apple.Terminal - 2>/dev/null | plutil -extract "Window Settings.$1" xml1 -o /dev/null - >/dev/null 2>&1
}

install_terminal_profile() {
	local name="Retro"
	
	if terminal_profile_exists "$name"; then
		echo "Terminal profiel "$name" already installed"
	else
		open -a Terminal "$DOTFILES/terminal/$name.terminal"
		sleep 3
		echo "Imported Terminal profile '$name'"
	fi
	
	defaults write com.apple.Terminal "Default Window Settings" -string "$name"
	defaults write com.apple.Terminal "Startup Window Settings" -string "$name"

	echo "Set '$name' as the default Terminal profile (restart Terminal if it was opended)"
}

if [[ "$(uname)" == "Darwin" ]]; then
	install_terminal_profile
fi

[[ -e "$HOME/.zsh.local" ]] || echo "Note: create ~/.zsh.local for work config and secrets (see README)"
