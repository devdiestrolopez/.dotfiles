DOTFILES_ZSH="${${(%):-%x}:A:h}"			# Directory of this file, with the ~/.zshrc symlink resolved

# Core: always loaded, in this order (path before completion so compinit sees Homebrew's fpath;
# colors before completion so list-colors can read LS_COLORS)
for file in options history env path colors completion aliases errors keybindings; do
	source "$DOTFILES_ZSH/core/$file.zsh"
done

# Modules: every .zsh file under modules/, in alphabetical order
for file in "$DOTFILES_ZSH"/modules/**/*.zsh(N); do
	source "$file"
done

[[ -r "$HOME/.zsh.local" ]] && source "$HOME/.zsh.local"		# Work config and secrets (untracked)

unset file
