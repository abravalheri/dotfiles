# disabled for now :-(
# set -g status-left '#(~/.common-public/bin/tmux_status)'
# set -g status-interval 1
set -g status-left '#[bg=colour236,fg=colour246] [#[fg=colour231]#S#[fg=colour246]] #[default]'
set -g status-left-length 50
set -g status-bg colour252
set -g status-right " %H:%M %d-%b-%y "
setw -g window-status-separator ""
setw -g window-status-format " #I:#{?window_flags,#{window_flags},}#W "
setw -g window-status-current-format " #I:#{?window_flags,#{window_flags},}#W "
setw -g window-status-current-bg colour236
setw -g window-status-current-fg colour156
setw -g window-status-current-attr bright
