alias ls="ls -G"			# Colorize ls output
alias ll="ls -lAh"			# Logn listing with hidden files and human-readable size

# Guard rm: require confirmation for recursive/force flags
unalias rm 2>/dev/null

rm() {
	local arg reply
	local -i risky=0

	for arg in "$@"; do
		[[ $arg == -- ]] && break				# End of options
		if [[ $arg == --recursive || $arg == --force ]]; then
			risky=1
			break
		elif [[ $arg == -[!-]*[rRf]* ]]; then
			risky=1
			break
		fi
	done

	if (( risky )); then
		printf '\033[1;33mWARNING:\033[0m rm with recursive/force flags: rm %s\n' "$*" >&2
		printf 'This can permanently delete files without further prompts.\n' >&2
		printf 'Are you sure you want to continue? [y/N] ' >&2

		if ! read -r reply <dev/tty; then
			printf '\nNo terminal avaialable; aborting.\n' >&2
			return 1
		fi
		
		case $reply in
			[yY] | [yY][eE][sS]) ;;
			*) printf 'Aborted.\n' >&2; return 1 ;;
		esac
	fi

	command rm "$@"
}
