command_not_found_handler() {
	printf '\e[38;5;196mzsh: command not found: %\e{0m\n' "$1" >&2
	return 127
}
