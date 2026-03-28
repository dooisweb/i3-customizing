#!/bin/bash
# Deploy i3 config files to their proper locations
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.config/i3 ~/.config/i3status ~/.config/dunst

cp "$SCRIPT_DIR"/i3/config ~/.config/i3/config
cp "$SCRIPT_DIR"/i3/status_wrapper.sh ~/.config/i3/status_wrapper.sh
cp "$SCRIPT_DIR"/i3/status_wrapper_edp.sh ~/.config/i3/status_wrapper_edp.sh
cp "$SCRIPT_DIR"/i3/monitors.sh ~/.config/i3/monitors.sh
cp "$SCRIPT_DIR"/i3/weather.sh ~/.config/i3/weather.sh
cp "$SCRIPT_DIR"/i3status/config ~/.config/i3status/config
cp "$SCRIPT_DIR"/redshift.conf ~/.config/redshift.conf
cp "$SCRIPT_DIR"/dunst/dunstrc ~/.config/dunst/dunstrc

chmod +x ~/.config/i3/status_wrapper.sh
chmod +x ~/.config/i3/status_wrapper_edp.sh
chmod +x ~/.config/i3/monitors.sh
chmod +x ~/.config/i3/weather.sh

# Dark theme for libadwaita apps
mkdir -p ~/.local/share/applications
cp "$SCRIPT_DIR"/desktop-overrides/org.gnome.Nautilus.desktop ~/.local/share/applications/
cp "$SCRIPT_DIR"/.xsessionrc ~/.xsessionrc

echo "i3 config installed. Reload i3 with Mod+Shift+R."
