# utf8
setw -g utf8 on
set -g status-utf8 on

# Mouse integration
set -g mouse-utf8 on
set -g mouse on

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
source-file "$DOTFILES/tmux/style/barebone.tmux"

# integrated clipboard
if-shell "uname | grep -qi Linux && which xclip > /dev/null && [[ -n $DISPLAY ]]" 'source-file "$DOTFILES/tmux/clipboard.tmux"'
