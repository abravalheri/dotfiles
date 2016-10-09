# default statusbar colors
set -g status-fg white
set -g status-bg default

# default window title colors
set-window-option -g window-status-fg white
set-window-option -g window-status-bg default
set-window-option -g window-status-attr dim

# active window title colors
set-window-option -g window-status-current-fg white
set-window-option -g window-status-current-bg default
set-window-option -g window-status-current-attr bright

# statusline
set -g status-left '#[fg=green][ #H ]['
set -g status-right '#[fg=green]][ #[fg=blue]%Y-%m-%d #[fg=white]%I:%M #[fg=green]]'
