# This tmux statusbar config was created by tmuxline.vim
# on Wed, 18 Mar 2015

set -g status-bg "colour16"
set -g message-command-fg "colour15"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour235"
set -g message-bg "colour26"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour15"
set -g message-command-bg "colour26"
set -g status-attr "none"
set -g pane-border-fg "colour16"
set -g status-left-attr "none"
setw -g window-status-fg "colour243"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour243"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "colour16"
setw -g window-status-separator ""
setw -g window-status-bg "colour16"
set -g status-left "#[fg=colour46,bg=colour235] #S #[fg=colour235,bg=colour16,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour16,bg=colour16,nobold,nounderscore,noitalics]#[fg=colour46,bg=colour16] #(whoami)@#H #[fg=colour16,bg=colour16,nobold,nounderscore,noitalics]#[fg=colour15,bg=colour16]  %b %d #[fg=colour16,bg=colour16,nobold,nounderscore,noitalics]#[fg=colour15,bg=colour16] %l:%M %P "
setw -g window-status-format "#[fg=colour16,bg=colour16,nobold,nounderscore,noitalics]#[default] #F#I #W #[fg=colour16,bg=colour16,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=colour16,bg=colour26,nobold,nounderscore,noitalics]#[fg=colour15,bg=colour26,bold] #F#I #W #[fg=colour26,bg=colour16,nobold,nounderscore,noitalics]"
