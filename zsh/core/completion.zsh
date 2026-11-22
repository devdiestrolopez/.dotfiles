mkdir -p "$HOME/.cache/zsh"			# Make sure cache directory exists
autoload -Uz compinit && compinit -d "$HOME/.cache/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
