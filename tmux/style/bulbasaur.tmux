# This tmux statusbar config was created by tmuxline.vim
# on Sun, 09 Oct 2016

set -g status-bg "colour232"
set -g message-command-fg "colour41"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour241"
set -g message-bg "colour234"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour41"
set -g message-command-bg "colour234"
set -g status-attr "none"
set -g pane-border-fg "colour232"
set -g status-left-attr "none"
setw -g window-status-fg "colour243"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour243"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "colour232"
setw -g window-status-separator ""
setw -g window-status-bg "colour232"
set -g status-left "#[fg=colour252,bg=colour241] #S #[fg=colour241,bg=colour232,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour232,bg=colour232,nobold,nounderscore,noitalics]#[fg=colour241,bg=colour232] #(whoami)@#H #[fg=colour232,bg=colour232,nobold,nounderscore,noitalics]#[fg=colour252,bg=colour232] %b %d #[fg=colour232,bg=colour232,nobold,nounderscore,noitalics]#[fg=colour41,bg=colour232] %l:%M %P "
setw -g window-status-format "#[fg=colour232,bg=colour232,nobold,nounderscore,noitalics]#[default] #F#I #W #[fg=colour232,bg=colour232,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=colour232,bg=colour234,nobold,nounderscore,noitalics]#[fg=colour41,bg=colour234,bold] #F#I #W #[fg=colour234,bg=colour232,nobold,nounderscore,noitalics]"
