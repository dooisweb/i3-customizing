# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal i3 window manager configuration for an AMD laptop (eDP) used with two external monitors (HDMI-A-0 at 2560x1440@144, DisplayPort-0 at 1920x1080@100). Files live here in the repo and are deployed into `~/.config/` and `~/` via `install.sh`. Editing files in `~/.config/i3/` directly will be overwritten on the next install — always edit the repo copies.

## Deploy / reload

```sh
./install.sh                  # copies configs into ~/.config and ~/
# Then either:
i3-msg reload                 # reload i3 config
i3-msg restart                # restart i3 in place (preserves layout)
# Or Mod+Shift+R inside i3.
```

No build, lint, or test suite. Validate i3 config syntax with `i3 -C -c ~/.config/i3/config` after editing.

## Architecture

**`install.sh`** is the single source-of-truth deployer. Every new file added to the repo that needs to live under `~/.config/` must be added here. It also chmod+x's the shell scripts.

**`i3/config`** declares three `bar {}` blocks — one per output (HDMI-A-0, eDP, DisplayPort-0). Only HDMI-A-0's bar carries the tray and the rich status; the eDP bar is intentionally suppressed when an external is present (see below); DisplayPort-0's bar has no status_command.

**Status bar pipeline** (`i3/status_wrapper.sh`):
- Spawns `i3status -c ~/.config/i3status/config` and parses its JSON stream line-by-line.
- For each tick, it *replaces* the i3status output with a custom JSON array — i3status's `battery` value is parsed out of its line, but all other blocks (volume, CPU temp, RAM bar, weather, dates, BR/NL clocks) are computed fresh in bash. The i3status config is essentially just a battery feed plus the JSON framing.
- Volume via `pactl get-sink-volume @DEFAULT_SINK@`, CPU temp from `/sys/class/thermal/thermal_zone0/temp`, RAM from `/proc/meminfo`.
- Weather is cached in `/tmp/weather.txt` and refreshed by `i3/weather.sh` in the background every 10 minutes.

**`i3/status_wrapper_edp.sh`** is a guard: if HDMI-A-0 is connected, it emits an empty i3bar JSON stream (so the laptop's eDP bar stays blank, avoiding duplicate info on the small screen); if not connected, it `exec`s the full `status_wrapper.sh`. This is why the eDP bar appears empty when docked — that is intentional.

**`i3/monitors.sh`** is run via `exec_always` and handles all 4 xrandr permutations (laptop only, +HDMI, +DP, +both). Primary output is HDMI-A-0 when connected, else eDP. Any monitor changes belong in this script, not in `i3/config`.

**Volume keys** use `amixer` (not `pactl`) — the `pactl` bindings are commented out in `i3/config`. Keep this consistent if adding new audio bindings.

**Theming**: dark libadwaita via `desktop-overrides/org.gnome.Nautilus.desktop` (sets `ADW_DEBUG_COLOR_SCHEME=prefer-dark`) plus the same env var exported globally in `.xsessionrc`. `redshift.conf` is location-pinned to Eindhoven.

## Conventions

- `resuming.md` and `logs/` are gitignored scratch space — don't commit them.
- Always commit AND push after editing config files (per user preference). Batch related edits into one commit.
