alias gfp="git fetch && git pull && clear"
alias gu="git reset HEAD~1 --mixed"
alias gpho="git push -u origin HEAD"
alias gp="git push"

# Commit all tracked chages with the given message
gac() {
	git commit -am "$1"
}

# Switch to master (or main if the repo has not master)
gsm() {
	local branch
	for branch in master main; do
		if git show-ref --verify --quiet "refs/heads/$branch" || git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
			git switch "$branch"
			return
		fi
	done
	echo "gsm: neither master nor main found" >&2
	return 1
}
