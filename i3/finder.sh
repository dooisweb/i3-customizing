#!/bin/sh
# Spotlight-like instant file search (Super+Space).
#
# Three modes:
#   (default)  launch a small floating alacritty running this script in --fzf mode
#   --fzf      the fzf UI; re-runs `--query` on every keystroke so it stays instant
#   --query Q  per-keystroke plocate lookup: paths under $HOME matching Q
#
# Per-keystroke querying is what keeps it fast regardless of how many files are
# indexed (the popup only ever holds the matches for what you typed), unlike
# dumping the whole home tree into the picker.

SELF="$HOME/.config/i3/finder.sh"

case "$1" in
  --query)
    q="$2"
    # plocate uses trigrams; queries shorter than 3 chars force a slow full scan.
    [ "${#q}" -lt 3 ] && exit 0
    plocate -i -- "$q" 2>/dev/null \
      | grep -E "^$HOME/" \
      | grep -vE '(^|/)\.|/node_modules/|/__pycache__/' \
      | head -n 500
    ;;
  --fzf)
    sel=$(fzf --disabled --ansi --layout=reverse --no-multi \
              --prompt 'Find a file: ' --info=inline --pointer='▶' \
              --color='bg+:#2f6fed,fg+:#ffffff,hl+:#ffffff,hl:#7aa2f7,pointer:#ffffff,prompt:#7aa2f7,info:#666666,gutter:-1' \
              --bind "change:reload($SELF --query {q})" \
              < /dev/null)
    # setsid so the opened app outlives this terminal when it closes.
    [ -n "$sel" ] && setsid xdg-open "$sel" >/dev/null 2>&1
    ;;
  *)
    exec alacritty --class finder \
      -o font.size=11 -o font.offset.y=8 \
      -e "$SELF" --fzf
    ;;
esac
