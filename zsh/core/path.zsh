typeset -U path

# Add Homebrew to PATH if installed
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Prepend ~/.local/bin if it exists
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Prepend ~/bin if it exists
[[ -d "$HOME/bin" ]] && path=("$HOME/bin" $path)
