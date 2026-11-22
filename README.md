# dotfiles

Personal macOS setup: zsh, Vim and Terminal.app theme. Core settings apply everywhere, modules hold one domain each, and anything work-related or secrets stays out of this repo.

## Install

```bash
git clone <this-repo> ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` is safe to re-run. It:

1. Symlinks `zsh/.zshrc` to `~/.zshrc`, `vim/vimrc` to `~/.vimrc` and `git/config` to `~/.config/git/config` (an existing file is moved to `<name>.bak`).
2. Installs Homebrew if it is missing (asks first), then runs `brew bundle` witih the `Brewfile`.
3. Imports the **Retro** Terminal.app profile if it is not there yet, and makes it the default.

Use `./install.sh --no-brew` to skip the Homebrew step.

## Layout
```
.dotfiles/
|-- install.sh				symlinks, Homebrew, Terminal profile
|-- Brewfile				what the dotfiiles depend on (Nerd Font, gh, git-lfs)
|-- zsh/
|    |-- .zshrc				entry point, symlinked to ~/.zshrc
|    |-- core/				always loaded: options, history, env, path, colors, completion, aliases, errors
|    |
|    |-- modules/			one domain per file or folder: prompt, git, android
|-- vim/vimrc				Vim config, symlinked to ~/.vimrc
|-- terminal/Retro.terminal		Terminal.app profile (colors, palette, font)
|-- git/config				global git settings, symlinked to ~/.config/git/config
```

## How zsh loads

1. **Core**, in a fixed order set in `zhs/.zshrc`. The order matters: `path` comes before `completion` (so `compinit` sees Homebrew's completion), and `colors` comes before `completion` (so completion can read `LS_COLORS`).
2 **Modules**, every `.zsh` file under `zsh/modules`, in alphabetical order, with no registration needed.
3. **`~/.zsh.local`**, last, so it can overrride anything.

Core is for things that affet thew whole shell. A modujle is for one domain, and removing it should remove everything that domain added.

## `~/.zsh.local` (not in this repo)

Everything that is work-specific, machine-specific or secret lives in `~/.zsh.local`, which is untracked. Keep it mode 600. It currently holds:

- `GITHUB_TOKEN`, read from `gh auth token`.

Git works the same way: `git/config` holds the general settings, and `~/.gitconfig` (untracked, it overrides the former) holds the identity, work tooling and the Git LFS filter that `git lfs install` writes.

Nothing in this repo should contain a token or a company-internal path.

## Prompt and font

The prompt (`zsh/modules/prompt.zsh`) uses Nerd Font glyphs for its icons and arrow separators, so it needs a Nerd Font in the terminal. The `Brewfile` installs **Departure Mono Nerd Font**, and the Retro profile selects its normal variant. In any other font, the icons show as empty boxes.

THe prompt shows:
- Left: `λ` (green, red after a failure) > directory (house, laptop or folder icon) > git branch.
- Right: red exit code (after failure) | command duration | clock.
- A blank line before each prompt.

Failed commands also turn `λ` red, and a mistyped command prints `command not found` in red.

## Terminal profile

`terminal/Retro.terminal` is exported from Terminal.app. `install.sh` imports it only if a profile called "Retro" does not exist, because Terminal.app creates a new profile on every import.

To update it after changing the profile in Terminal.app, export the profile again and replace the file. To re-import an updated file, delete the old Retro profile in Terminal -> Settings -> Profiles first.

## Adding things

- **A zsh domain:** drop `zsh/modules/<name>.zsh` (or a folder of files) in. It is loaded automatically.
- **A global zsh setting:** add `zsh/core/<name>.zsh and add `<name>` to the list in `zsh/.zshrc`.
- **A tool the dotfiles need:** add it to the `Brewfile`.
