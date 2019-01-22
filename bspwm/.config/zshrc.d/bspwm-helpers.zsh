#!/usr/bin/env zsh

sxhkd-reload() {
  pkill -USR1 sxhkd &>/dev/null | true
}

yabar-reload() {
  pkill yabar &>/dev/null | true
  yabar &>/dev/null &
}

bspwm-reset-monitors() {
  IFS=$'\n' monitors=( $(bspc query --monitors --names) )
  for mon in "${monitors[@]}"; do
    bspc monitor "$mon" --reset-desktops {1..4}
  done
}

bspwm-config-ui() {
  bspc config window_gap             10
  bspc config border_width           2
  bspc config focused_border_color   '#00E676'
  bspc config presel_feedback_color  '#00E676'

  bspc config split_ratio            0.52
  bspc config borderless_monocle     true
  bspc config gapless_monocle        true
}

bspwm-config-rules() {
  bspc rule -a '*:zathura' state=tiled
  bspc rule -a Emacs state=tiled
  bspc rule -a emacs state=tiled
  bspc rule -a Surf state=tiled
}

bspwm-reload() {
  bspwm-reset-monitors
  bspwm-config-ui
  bspwm-config-rules
}

feh-configure-wallpaper() {
  local wallpaper=$HOME/.config/wallpapers/background
  if [ -f "$wallpaper" ]; then
    feh --bg-center "$wallpaper"
  fi
}

desktop-environment-reload() {
  bspwm-reload
  yabar-reload
  feh-configure-wallpaper
  sxhkd-reload
}
