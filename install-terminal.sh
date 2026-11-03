#!/usr/bin/env bash
# Install all terminal/editor tools and activate portable Zsh settings.
set -euo pipefail
config_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Install it first, then rerun this script.\n' >&2
  exit 1
fi
brew bundle --file="$config_root/Brewfile"

# Oh My Zsh itself has no Homebrew formula. Reuse the user's copy when present.
if [[ ! -r "${ZSH:-$HOME/.oh-my-zsh}/oh-my-zsh.sh" && ! -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" &&
      ! -r "$config_root/zsh/vendor/oh-my-zsh/oh-my-zsh.sh" ]]; then
  mkdir -p "$config_root/zsh/vendor"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$config_root/zsh/vendor/oh-my-zsh"
fi

# Match the source's Pokémon tool. Build locally because v0.3.0's go.mod has
# a module-name typo, which prevents a plain `go install ...@v0.3.0`.
if [[ ! -x "$config_root/bin/pokego" || ! -r "$config_root/bin/.pokego-version" ]] ||
    [[ $(cat "$config_root/bin/.pokego-version" 2>/dev/null || true) != v0.3.0 ]]; then
  build_dir=$(mktemp -d)
  trap 'rm -rf -- "$build_dir"' EXIT
  git clone --depth=1 --branch=v0.3.0 https://github.com/rubiin/pokego.git "$build_dir/pokego"
  mkdir -p "$config_root/bin"
  (cd "$build_dir/pokego" && CGO_ENABLED=0 go build -trimpath -o "$build_dir/pokego-bin" .)
  mv "$build_dir/pokego-bin" "$config_root/bin/pokego"
  printf 'v0.3.0\n' > "$config_root/bin/.pokego-version"
fi

python3 "$config_root/zsh/activate.py" "$config_root/zsh/portable.zsh"
printf '\nInstalled and configured. Open Kitty to start tmux with the new Zsh setup.\n'
printf 'For Docker aliases, start the engine when needed with: colima start\n'
