# Use vim keybindings in copy mode
setw -g mode-keys vi

# Open windows/panels in the current dir
bind | split-window -h -c "#{pane_current_path}"
bind % split-window -v -c "#{pane_current_path}"
bind c new-window      -c "#{pane_current_path}"

# Switch panes using Ctrl-arrow without prefix
unbind -n C-Left
unbind -n C-Right
unbind -n C-Up
unbind -n C-Down

bind   -n C-Left  select-pane -L
bind   -n C-Right select-pane -R
bind   -n C-Up    select-pane -U
bind   -n C-Down  select-pane -D

# Resize panes using Alt-arrow without prefix
unbind -n M-Left
unbind -n M-Right
unbind -n M-Up
unbind -n M-Down

bind   -n M-Left  resize-pane -L 10
bind   -n M-Right resize-pane -R 10
bind   -n M-Up    resize-pane -U 10
bind   -n M-Down  resize-pane -D 10

# Move to the last pane and zoom it
unbind -n M-z
bind   -n M-z last-pane \; run-shell 'sleep 0.2 && tmux resize-pane -Z'

# Switch windows using Shift-arrow without prefix
unbind -n S-Left
unbind -n S-Right

bind   -n S-Left  previous-window
bind   -n S-Right next-window

bind R source-file "$HOME/.tmux.conf" \; display "tmux reloaded!"
