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
run "$HOME/.config/tmux/clipboard.sh"

## --- Key Bindings ---
source "$HOME/.config/tmux/keybindings.tmux"
