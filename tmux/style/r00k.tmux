###########################
# Status Bar
###########################

# enable UTF-8 support in status bar

# center the status bar
set -g status-justify left

###########################
# Colors
###########################

# color status bar
set -g status-bg colour235
set -g status-fg white

# highlight current window
set-window-option -g window-status-current-fg black
set-window-option -g window-status-current-bg green

# set color of active pane
set -g pane-border-fg colour235
set -g pane-border-bg black
set -g pane-active-border-fg green
set -g pane-active-border-bg black
