# This tmux statusbar config was created by tmuxline.vim
# on Sun, 09 Oct 2016

set -g status-bg "colour234"
set -g message-command-fg "colour231"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour254"
set -g message-bg "colour31"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour231"
set -g message-command-bg "colour31"
set -g status-attr "none"
set -g pane-border-fg "colour240"
set -g status-left-attr "none"
setw -g window-status-fg "colour250"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour234"
setw -g window-status-activity-attr "underscore"
setw -g window-status-activity-fg "colour250"
setw -g window-status-separator ""
setw -g window-status-bg "colour234"
set -g status-left "#[fg=colour16,bg=colour254,bold] #S #[fg=colour254,bg=colour234,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour232,bg=colour234,nobold,nounderscore,noitalics]#[fg=colour250,bg=colour232] #(whoami)@#H #[fg=colour236,bg=colour232,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236]  %b %d #[fg=colour252,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour235,bg=colour252] %l:%M %P "
setw -g window-status-format "#[fg=colour234,bg=colour234,nobold,nounderscore,noitalics]#[default] #F#I #W #[fg=colour234,bg=colour234,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=colour234,bg=colour31,nobold,nounderscore,noitalics]#[fg=colour231,bg=colour31,bold] #F#I #W #[fg=colour31,bg=colour234,nobold,nounderscore,noitalics]"