# Kitty, Zsh, Neovim, and tmux without Nix

These are active configurations for this Apple Silicon Mac, translated from
[miloswrath/nix-conf](https://github.com/miloswrath/nix-conf/tree/9aead75978c9b7782fb66aff716fd54ec1919d71).
No existing Neovim or tmux configuration was present when these files were created.

## Step 1 — Install the applications

Homebrew and Apple's command line tools are already installed here. Run the
installer to install the complete Brewfile and activate the Zsh hook automatically:

```sh
bash "$HOME/.config/install-terminal.sh"
```

The installer runs this package installation command, then builds the source's
Pokémon helper and adds one backed-up hook to your existing `.zshrc`:

```sh
brew bundle --file="$HOME/.config/Brewfile"
```

Neovim and tmux are the applications. Ripgrep, fd, and fzf power searches and the
project picker; lazygit powers the Git shortcut. Node, Python, Go, Rust, CMake,
and tree-sitter-cli let the plugin installers provide the language tools and
syntax parsers from the original setup. Astyle supplies its C/C++ formatter.
Neovim must be at least 0.11.3; current Homebrew Neovim is supported.

## Step 2 — Configuration is already prepared

The applications discover these files automatically:

- `~/.config/nvim/init.lua`, with Lua modules under `nvim/lua/`.
- `~/.config/tmux/tmux.conf`, with the three required tmux plugins included locally.
- `~/.config/tmux/scripts/tmux-sessionizer`, invoked directly by its tmux binding.
- `~/.config/kitty/kitty.conf`, including its local Catppuccin Mocha theme.
- `~/.config/zsh/portable.zsh`, loaded by the hook the installer adds to `.zshrc`.

Open Kitty after installing. It starts tmux automatically; then run `nvim`.
In another terminal you can still start them manually:

```sh
tmux
nvim
```

On its first launch, Neovim downloads lazy.nvim, its plugins, syntax parsers,
language servers, formatters, linters, and debugger adapters automatically.
Leave that first session open until installation finishes; it can take several
minutes, particularly when Rust tools compile. Internet access to GitHub and
package registries is required. No manual plugin-install commands, symlinks,
Nix installation, or config edits are required. If a download fails, `:Lazy`
and `:Mason` show the failure; reopening Neovim retries missing dependencies.

If tmux was already running before these files were created, reload it once with
`tmux source-file "$HOME/.config/tmux/tmux.conf"`; new servers read the file automatically.

## Everyday keys

Neovim's leader is **Space**. These bindings apply in normal mode unless noted.

| Keys | Action |
| --- | --- |
| Ctrl+n | Toggle file explorer |
| Space Space / Space ff | Find files |
| Space / / Space fg | Search file contents |
| Space fb | Switch buffers |
| Shift+h / Shift+l | Previous / next buffer |
| Ctrl+h/j/k/l | Move between editor windows and tmux panes |
| Ctrl+s | Save; in completion menus, confirm the suggestion |
| Space fm | Format buffer |
| Space l | Lint buffer |
| gd / gr / K | Definition / references / documentation |
| Space rn / Space ca | Rename symbol / code action |
| Space gg | Open lazygit in a tmux window |
| Alt+f | Floating terminal |
| gcc / gc in visual mode | Toggle comments |
| Space hw | Jump to a word |
| Space b / F5 | Toggle breakpoint / start or continue debugger |
| F10 / F11 / F12 | Debug step over / into / out |
| Space dt | Toggle debugger UI |
| zR / zM / zK | Open folds / close folds / peek fold |
| Space rs | Restore saved project session |
| Space cc / ce / co | Copilot chat / explain / optimize |
| Space qq | Quit all |

Tmux's prefix is **Ctrl+a**: press and release it, then the following key.

| Keys after Ctrl+a | Action |
| --- | --- |
| c | New window in the current directory |
| \| / - | Split left/right / top/bottom |
| h/j/k/l | Select pane |
| f | Pick a project directory and create/switch session |
| r / R | Rename window / reload config |
| z / x | Zoom pane / swap pane downward |
| [ | Enter copy mode; use v to select and y to copy |
| d | Detach, leaving the session running |

Shift+Left/Right changes windows without a prefix. Alt+arrow resizes panes.
The repository's direct Ctrl+Alt+c binding kills the current pane.

## Source and migration notes

The source repository selects **Nixvim**, rather than its alternate plain
`neovim` module. Its `flake.lock` pins
[nixvim-but-worse at 66d4eb08](https://github.com/miloswrath/nixvim-but-worse/tree/66d4eb08e9ffc6778b6cc93426da32463e3413c7).
That pinned configuration is the basis of this translation.

The translation includes the active editor options, mappings, autocmds, Catppuccin
Mocha theme, dashboard, file tree, buffer/status lines, Telescope search, completion,
snippets, Copilot chat, Git integration, project detection, terminals, folding,
formatting, linting, debugging, and session persistence. Disabled upstream plugins
(Flash, CMake project integration, Discord presence, and alternate themes) remain
disabled. Tmux resurrection/continuum were commented out upstream and are not enabled.

Platform and compatibility changes:

- Home Manager plugin declarations become lazy.nvim specs; language tools use
  Mason. The first successful plugin installation creates `nvim/lazy-lock.json`.
  Plugin versions are resolved then, rather than reproducing the Nixpkgs package set.
- Clipboard access uses Neovim's macOS pbcopy/pbpaste provider instead of wl-copy/xclip.
- CodeLLDB replaces Linux GDB and hard-coded Nix store debugger paths. Java remote
  debugging still requires a Java adapter supplied by project tooling. Debugging
  compiled code requires an executable built with debug information.
- The project picker searches existing macOS directories under your home instead of
  the original author's `/mnt` and personal work folders. It handles cancellation,
  spaces, invalid directories, and duplicate project names.
- New Treesitter uses its current Neovim 0.12 API; Neovim 0.11 uses the frozen
  compatibility branch. Highlighting, indentation, and parsers are configured in
  both cases; the old incremental-selection module is only available on 0.11.
  Nixvim-specific injection queries are not bundled; Treesitter's upstream queries apply.
- Project detection uses the maintained `DrKJeff16/project.nvim` fork and its
  current API, avoiding the old plugin's removed LSP client APIs.
- Invalid upstream keys/options are corrected (including `<leeader>sk`, `aync`,
  CSV display settings, the Markdown linter filetype, and chat shortcuts). The
  overlapping Ctrl+k mapping uses insert mode for LSP signature help, leaving
  normal mode for pane navigation. Dashboard text identifies the plain Lua setup.
- Nix linting activates only if `nix` is already installed. Nix is unnecessary
  for the editor itself. Erlang/Elixir servers from the source's extra raw setup,
  Zellij integration, and unrelated unused tool packages are not installed.
  Direnv integration activates only if you separately use direnv.
- Copilot authentication is personal: its features require your own account and
  `:Copilot auth`. The editor otherwise works without it. Plugins cannot supply
  your credentials. Icons render best with a Nerd Font selected in your terminal;
  a terminal's own font and key handling settings remain under its control.
- Shell-wide `vi`/`vim` aliases were not added; launch the configured editor as `nvim`.

Tmux plugins are vendored with licenses:

| Plugin | Commit |
| --- | --- |
| dreamsofcode-io/catppuccin-tmux | b4e0715356f820fc72ea8e8baf34f0f60e891718 (same as source) |
| tmux-plugins/tmux-sensible | 25cb91f42d020f675bb0a2ce3fbd3a5d96119efa |
| christoomey/vim-tmux-navigator | e41c431a0c7b7388ae7ba341f01a0d217eb3a432 |

The source MIT license is in `LICENSE.nix-conf`; the editor source license is in
`nvim/LICENSE.upstream`.

## Kitty and Zsh

Run `bash "$HOME/.config/install-terminal.sh"` to install the added tools and
activate Zsh. The installer preserves your existing `.zshrc`, saves a timestamped
backup beside it, and appends one hook to `zsh/portable.zsh`. Running it again
does not duplicate the hook. Existing PATH settings and local aliases remain in
your original file; the portable settings load afterward. A custom `ZDOTDIR` is
respected. This workspace cannot write your home `.zshrc` directly, so activation
is performed by the installer when you run it.

Kitty reads `kitty/kitty.conf` automatically. It includes the source's Catppuccin
Mocha theme, JetBrainsMono Nerd Font at size 12, animated cursor trail, powerline
tabs, copy-on-select, 10,000 scrollback lines, Option-as-Alt, disabled bell,
and macOS close behavior. A login shell initializes your existing environment
before starting tmux. Kitty's local theme file requires no online theme setup.

| Kitty keys | Action |
| --- | --- |
| Ctrl+Alt+n | New Kitty window in the current directory |
| Alt+w | Copy selection and clear it, or interrupt |
| Ctrl+y | Paste clipboard |
| Alt+1 … Alt+9, Alt+0 | Select Kitty tabs 1 … 10 |
| Ctrl+t | Project picker overlay |

The project picker receives the originating Kitty window ID and matches the tmux
client for that window, so another open Kitty terminal isn't switched by accident.
If the originating client cannot be identified, it opens the chosen session inside
the overlay instead. Detach with Ctrl+a d to close that fallback overlay.

Zsh includes the upstream Pure-style Powerlevel10k prompt, Oh My Zsh's `git`,
`gitignore` (`gi`), and directory-jumping (`z`) plugins, autosuggestions, syntax
highlighting, completion, a 100,000-entry shared history, and the direnv hook.
The FZF colors match the source's Macchiato palette. Powerlevel10k's exact source
settings are in `zsh/.p10k.zsh`; the installer does not replace your existing
home `.p10k.zsh`. No prompt configuration wizard is needed.

Portable shell commands retained:

| Commands | Behavior / installed tool |
| --- | --- |
| `l`, `ls`, `ll`, `ld`, `tree` | eza lists, icons, and directory trees |
| `nv`, `vc`, `cls` | Neovim, VS Code, clear |
| `tml`, `attach`, `att`, `tmux-sessionizer` | tmux helpers |
| `y`, `lf` | Yazi/lf and change to their final selected directory |
| `ex archive …` | Extract supported archives, including filenames with spaces |
| `cbuild`, `crun` | Configure/build a CMake project; run `build/main` |
| `cp`, `mv`, `rm` | GNU tools with the source's verbose/interactive flags |
| `bc`, `mkd`, `grep` | Calculator, recursive mkdir, colored GNU grep |
| `tp`, `tpr` | trash-cli trash and restore |
| `nf` | fastfetch, the macOS replacement for Linux microfetch |
| `pokemon`, `cmat` | Source-pinned pokego v0.3.0 and magenta cmatrix |
| `dk`, `dku`, `dkd` | Docker CLI; Compose up/down |
| `G`, `UUID` | Global aliases for a grep pipe and a generated UUID |

Ctrl+l launches Yazi at a Zsh prompt outside tmux; inside tmux, its pane-navigation
binding takes precedence, so use `y` there. Ctrl+a / Ctrl+e move to the beginning /
end of the line; tmux likewise intercepts Ctrl+a as its prefix. `EDITOR` and `VISUAL`
select Neovim.

The Brewfile includes the aliases' applications, file-preview dependencies,
and archive tools. `ex` uses GNU tar, 7-Zip (`7zz`), unar for RAR/ACE, gzip/xz,
unzip, cabextract, and macOS's cpio. Keg-only trash-cli is located through Homebrew
without replacing macOS's `trash` command. It uses a FreeDesktop-style trash store,
not Finder's Trash. Docker uses Colima as its engine; run `colima start` when you
want to run containers. The installer does not start a VM on every shell launch.

Personal directory shortcuts, mount and SSH commands, Xmonad paths, and all
Nix-specific rebuild/template commands (`fnew`, `finit`, `cgen`, and related
aliases) are omitted. `vc` drops the Linux GPU workaround. No PATH assignment
from the source repository is copied.

Additional source modules:
[Kitty](https://github.com/miloswrath/nix-conf/blob/9aead75978c9b7782fb66aff716fd54ec1919d71/modules/programs/terminal/kitty/default.nix),
[Zsh](https://github.com/miloswrath/nix-conf/blob/9aead75978c9b7782fb66aff716fd54ec1919d71/modules/programs/shell/zsh/default.nix).

Zsh/Bash/Python/Ruby syntax checks pass. Isolated checks cover Zsh startup and
repeat sourcing, hook backup/idempotence/custom ZDOTDIR, directory-following
wrappers, ZIP extraction, and Kitty overlay client selection/fallback. Kitty's
option names were checked against upstream definitions. The new packages and
Kitty GUI startup remain pending the installer; shell network and package-directory
writes are restricted in this workspace.

## Validation

All Lua files pass a Lua 5.1 syntax parser, and all shell scripts pass `bash -n`.
The sessionizer is exercised using stub commands, including cancellation and paths
containing spaces. Full Neovim startup is pending application installation.
This workspace's sandbox blocks tmux server sockets and shell network access, so
  a live tmux/plugin startup and Neovim's first-run downloads could not be tested here.
