#!/usr/bin/env python3
"""Append one portable-config hook without replacing existing shell setup."""
import datetime
import os
from pathlib import Path
import shlex
import shutil
import sys


def activate(config: Path) -> None:
    if not config.is_file():
        raise SystemExit(f"Missing portable Zsh config: {config}")
    # Respect users who already place Zsh's rc files in a different directory.
    target = Path(os.environ.get("ZDOTDIR") or Path.home()) / ".zshrc"
    original = target.read_text() if target.exists() else ""
    marker = "# nix-conf portable terminal setup"
    if marker in original:
        print(f"Zsh hook already installed: {target}")
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists():
        stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        backup = target.with_name(f".zshrc.before-nix-conf-{stamp}")
        shutil.copy2(target, backup)
        print(f"Backed up existing Zsh configuration: {backup}")
    # Quote a literal path; never interpolate it into executable Python or shell code.
    with target.open("a") as output:
        output.write(f"\n{marker}\nsource {shlex.quote(str(config.resolve()))}\n")
    print(f"Activated portable Zsh configuration in {target}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: activate.py /path/to/zsh/portable.zsh")
    activate(Path(sys.argv[1]))
