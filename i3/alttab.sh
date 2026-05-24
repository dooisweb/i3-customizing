#!/bin/sh
# macOS-like Alt+Tab app switcher (alttab).
# Re-runnable from exec_always: kill any prior instance and wait for it to fully
# exit (-w) so i3 reloads don't stack daemons or fight over the Alt+Tab key grab.
#
# Flags:
#   -w 1        EWMH-compatible WM (i3)
#   -d 1        include windows from ALL workspaces (macOS-like)
#   -vp focus   show the popup on the currently focused monitor
#   -mk/-kk     modifier=Alt, key=Tab (Shift+Tab reverses by default via -bk)
#   -t/-i       small tile + large icon so each tile reads as an app icon
#   -s 1        icon source: window attributes, fall back to file
#   -bg/-fg/-frame match the repo dark theme (client.focused = #888888)
killall -w alttab 2>/dev/null

exec alttab \
  -w 1 \
  -d 1 \
  -vp focus \
  -mk Alt_L -kk Tab \
  -t 80x80 -i 64x64 \
  -s 1 \
  -bg '#1a1a1a' -fg '#ffffff' -frame '#888888' \
  -font 'xft:DejaVu Sans Mono-11'
