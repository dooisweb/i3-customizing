#!/bin/sh
# Spotlight-like file search (Super+Space). Pull paths under $HOME from the
# plocate index, drop hidden dirs and build noise, let rofi filter as you type,
# then open the selection with its default app (xdg-open opens folders in Nautilus).
sel=$(plocate "$HOME" 2>/dev/null \
  | grep -vE '(^|/)\.|/node_modules/|/__pycache__/' \
  | rofi -dmenu -i \
      -theme-str 'window { width: 70%; } listview { lines: 16; } prompt { enabled: false; } entry { placeholder: "Type a file name..."; }')

[ -n "$sel" ] && exec xdg-open "$sel"
