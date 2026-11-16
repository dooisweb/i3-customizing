# i3-customizing

Personal i3 config for an AMD laptop (eDP) with two external monitors (HDMI-A-0, DisplayPort-0). Repo files are deployed into `~/.config/` and `~/` by `./install.sh`; editing `~/.config/i3/` directly is overwritten on the next install — always edit the repo copies.

## Deploy and check

- `./install.sh`, then `i3-msg reload` (or `i3-msg restart` to keep the layout).
- No build, lint or tests. Validate syntax with `i3 -C -c ~/.config/i3/config` after editing.

## Gotchas

- `install.sh` is the only deployer: every new file that must live under `~/.config/` has to be added there (it also chmod +x's the scripts).
- `i3/status_wrapper.sh` replaces the i3status output with its own JSON; i3status only supplies the battery value. Weather is cached in `/tmp/weather.txt` and refreshed every 10 minutes by `i3/weather.sh`.
- The eDP bar is intentionally empty while HDMI-A-0 is connected (`i3/status_wrapper_edp.sh`); only the HDMI-A-0 bar carries the tray and the full status.
- Monitor changes belong in `i3/monitors.sh` (handles all 4 xrandr permutations; primary is HDMI-A-0 when connected, else eDP), not in `i3/config`.
- Volume keys use `amixer`, not `pactl` (the `pactl` bindings are commented out in `i3/config`); keep new audio bindings consistent.
