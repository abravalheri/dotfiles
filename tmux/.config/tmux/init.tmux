# Before hook
run '$HOME/.config/tmux/before.sh'

# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0

# increase scrollback buffer size
set -g history-limit 50000

# tmux messages are displayed for 4 seconds
set -g display-time 4000

# refresh 'status-left' and 'status-right' more often
set -g status-interval 5

# Automatically set window title
setw -g automatic-rename

# Avoid non 256 terminals
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Set window notifications
setw -g monitor-activity on
set -g visual-activity on

# focus events enabled for terminals that support them
set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on

## --- Bash extensions (better programmability) ---
run "$HOME/.config/tmux/utf-8.sh"
run "$HOME/.config/tmux/mouse.sh"
run "$HOME/.config/tmux/style.sh"
# run "$HOME/.config/tmux/clipboard.sh"

## --- Key Bindings ---
source "$HOME/.config/tmux/keybindings.tmux"


## --- Plugins ---
set-environment -g TMUX_PLUGIN_MANAGER_PATH '$HOME/.config/tmux/+plugins'

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-sessionist'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '$HOME/.config/tmux/+plugins/tpm/tpm'
