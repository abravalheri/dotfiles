# This tmux statusbar config was created by tmuxline.vim
# on Sun, 09 Oct 2016

set -g status-bg "colour236"
set -g message-command-fg "colour253"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour181"
set -g message-bg "colour239"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour253"
set -g message-command-bg "colour239"
set -g status-attr "none"
set -g pane-border-fg "colour239"
set -g status-left-attr "none"
setw -g window-status-fg "colour244"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour236"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "colour181"
setw -g window-status-separator ""
setw -g window-status-bg "colour236"
set -g status-left "#[fg=colour236,bg=colour181] #S #[fg=colour181,bg=colour236,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour236,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour244,bg=colour236] #(whoami)@#H #[fg=colour239,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour248,bg=colour239]  %b %d #[fg=colour246,bg=colour239,nobold,nounderscore,noitalics]#[fg=colour236,bg=colour246] %l:%M %P "
setw -g window-status-format "#[fg=colour236,bg=colour236,nobold,nounderscore,noitalics]#[default] #F#I #W #[fg=colour236,bg=colour236,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=colour236,bg=colour239,nobold,nounderscore,noitalics]#[fg=colour253,bg=colour239] #F#I #W #[fg=colour239,bg=colour236,nobold,nounderscore,noitalics]"
