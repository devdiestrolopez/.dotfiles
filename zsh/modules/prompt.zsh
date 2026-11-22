# Nerd Font glyphs, written as code points (they only render with a Nerd Font in the terminal)
_arrow_r=$'\xee\x82\xb0'			# Right-pointing arrow
_arrow_l=$'\xee\x82\xb2'		# Left-pointing arrow
_icon_branch=$'\xee\x82\xa0'		# Git branch
_icon_home=$'\xef\x80\x95'		# House
_icon_code=$'\xef\x84\x89'		# Laptop
_icon_folder=$'\xef\x81\xbb'		# Folder
_icon_timer=$'\xef\x94\xa0'		# Stopwatch
_icon_error=$'\xef\x80\x8d'		# Cross

autoload -Uz vcs_info add-zsh-hook			# Load the VCS info function and the hook helper
setopt prompt_subst					# Expand variables in the prompt on every redraw

zstyle ':vcs_info:*' enable git				# Only query git (skip other VCS backends)
zstyle ':vcs:info:git:*' formats "%K{25}%F{17}${_arrow_r}%F{153} ${_icon_branch} %b "

add-zsh-hook precmd vcs_info				# Refresh the branch info before each prompt

_prompt_state() {
	if [[ $PWD == $HOME ]]; then _dir_icon=$_icon_home
	elif [[ $PWD == $HOME/Projects || $PWD == $HOME/Projects/* ]]; then _dir_icon=$_icon_code
	else _dir_icon=$_icon_folder
	fi
	
	[[ -n $vcs_info_msg_0_ ]] && _prev_bg=25 || _prev_bg=17
}

add-zsh-hook precmd _prompt_state

PROMPT='%(?.%K{39}.%K{196})%F{black} λ %K{17}%(?.%F{39}.%F{196})${_arrow_r}%F{117} ${_dir_icon}  %~ ${vcs_info_msg_0_}%k%F{${_prev_bg}}${_arrow_r}%f'

zmodload zsh/datetime

_cmd_timer_start() { _cmd_start=$EPOCHREALTIME; }

_cmd_timer_stop() {
	local timer= elapsed secs

	if [[ -n $_cmd_start ]]; then
		elapsed=$(( EPOCHREALTIME - _cmd_start )); unset _cmd_start
		secs=${elapsed%.*}
		
		if (( secs < 60 )); then printf -v _cmd_duration '%.2fs' $elapsed
		elif (( secs < 3600 )); then printf -v _cmd_duration '%dm %02ds' $(( secs / 60 )) $(( secs % 60 ))
		else printf -v _cmd_duration '%dh %02dm %02ds' $(( secs / 3600 )) $(( secs % 3600 / 60 )) $(( secs % 60 ))
		fi

		# Duration lock (amber); its arrow sits on the red block's background when the last command failed
		timer="%(?.%F{214}.%K{196}%F{214})${_arrow_l}%K{214}%F{black} ${_icon_timer}  ${_cmd_duration} "
	fi

	_rp_timer=$timer
	
	# Clock block (blue); its arrow sits on the previous block's background
	if [[ -n $timer ]]; then _rp_clock="%K{214}%F{17}${_arrow_l}"
	else _rp_clock="%(?.%F{17}.%K{196}%F{17})${_arrow_l}"
	fi

	_rp_clock="%K{17}%F{117} %* %k%f"
}

add-zsh-hook preexec _cmd_timer_start			# Start the timer when a command begins
add-zsh-hook precmd _cmd_timer_stop			# Stop it just before the next prompt is drawn

RPROMPT='%(?..%F{196}${_arrow_l}%K{196}%F{black} ${_icon_error}  %? )${_pr_timer}${_rp_clock}'

# Print an empty line before each prompt, except the first one and the one after clean
_blank_line() {
	[[ -n $_prompt_drawn && -z $_skip_blank ]] && print
	_prompt_drawn=1
	unset _skip_blank
}

add-zsh-hook precmd _blank_line

# After a clear the cursor is at the top, so skip the gap there
clear() { command clear "@"; _skip_blank=1; }
