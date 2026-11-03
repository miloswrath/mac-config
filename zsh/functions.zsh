# Preserve lf's change-directory-on-exit behavior and clean up temporary files.
function lf {
  local tmp directory result
  tmp=$(mktemp) || return
  {
    command lf -last-dir-path="$tmp" "$@"
    result=$?
    if [[ -s $tmp ]]; then
      directory=$(<"$tmp")
      [[ ! -d $directory || $directory == $PWD ]] || builtin cd -- "$directory"
    fi
  } always {
    command 'rm' -f -- "$tmp"
  }
  return $result
}

# Home Manager enables Yazi's `y` wrapper, which follows the selected directory.
function y {
  local tmp directory result
  tmp=$(mktemp) || return
  {
    command yazi "$@" --cwd-file="$tmp"
    result=$?
    if [[ -s $tmp ]]; then
      directory=$(<"$tmp")
      [[ ! -d $directory || $directory == $PWD ]] || builtin cd -- "$directory"
    fi
  } always {
    command 'rm' -f -- "$tmp"
  }
  return $result
}

# Equivalent archive formats, using macOS-available extractors.
function ex {
  local archive result=0
  if (( $# == 0 )); then
    print 'Usage: ex archive [archive ...]'
    return 0
  fi
  for archive in "$@"; do
    if [[ ! -f $archive ]]; then
      print -u2 -- "File does not exist: $archive"
      return 1
    fi
    # Absolute paths prevent a filename beginning with '-' from becoming an option.
    archive=${archive:A}
    case ${archive:l} in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
        command gtar xvf "$archive" ;;
      *.lzma) command unlzma "$archive" ;;
      *.bz2) command bunzip2 "$archive" ;;
      *.gz) command gunzip "$archive" ;;
      *.cbr|*.rar|*.cba|*.ace) command unar "$archive" ;;
      *.cbz|*.epub|*.zip) command unzip "$archive" ;;
      *.z) command uncompress "$archive" ;;
      *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
        command 7zz x "$archive" ;;
      *.xz) command unxz "$archive" ;;
      *.exe) command cabextract "$archive" ;;
      *.cpio) command cpio -id < "$archive" ;;
      *) print -u2 -- "Unsupported archive format: $archive"; return 1 ;;
    esac
    result=$?
    (( result == 0 )) || return $result
  done
}

function cbuild {
  command cmake -S . -B build && command cmake --build build
}
function crun {
  cbuild && command ./build/main "$@"
}
