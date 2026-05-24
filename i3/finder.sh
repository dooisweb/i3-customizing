#!/bin/sh
# Spotlight-like file search (Super+Space). Pull paths under $HOME from the
# plocate index, drop hidden dirs and build noise, let rofi filter as you type,
# then open the selection with its default app (xdg-open opens folders in Nautilus).
sel=$(plocate "$HOME" 2>/dev/null \
  | grep -vE '(^|/)\.|/node_modules/|/__pycache__/' \
  | rofi -dmenu -i -p "Search" \
      -theme-str 'entry { placeholder: "Search files..."; }')

[ -n "$sel" ] && exec xdg-open "$sel"
