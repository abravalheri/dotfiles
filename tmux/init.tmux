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

## --- Version-specific commands [grumble, grumble] ---
# See: https://github.com/tmux/tmux/blob/master/CHANGES
# http://stackoverflow.com/a/40902312
run-shell 'tmux setenv -g TMUX_VERSION $(tmux -V | cut -d" " -f2)'

if-shell -b '[ "$(echo "$TMUX_VERSION < 2.1" | bc)" = 1 ]' \
  "set -g mouse-select-pane on; set -g mode-mouse on; \
   set -g mouse-resize-pane on; set -g mouse-select-window on"

# In version 2.1 "mouse" replaced the previous 4 mouse options
if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]' \
  "set -g mouse on"

# UTF8 is autodetected in 2.2 onwards, but errors if explicitly set
if-shell -b '[ "$(echo "$TMUX_VERSION < 2.2" | bc)" = 1 ]' \
  "set -g utf8 on; set -g status-utf8 on; set -g mouse-utf8 on"

## --- Key Bindings ---

# Use vim keybindings in copy mode
setw -g mode-keys vi

# Open windows/panels in the current dir
bind '"' split-window -h -c "#{pane_current_path}"
bind % split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# source .tmux.conf as suggested in `man tmux`
bind R source-file "$HOME/.tmux.conf" \; display "tmux reloaded!"

## --- Extras ---

# style
set-option -g status-position bottom
source-file "$DOTFILES/tmux/style/barebone.tmux"

# integrated clipboard
if-shell "uname | grep -qi Linux && command -v xclip &>/dev/null && [[ -n $DISPLAY ]]" 'source-file "$DOTFILES/tmux/clipboard.tmux"'
