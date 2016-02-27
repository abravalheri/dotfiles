# retangle mode
bind-key -t vi-copy V rectangle-toggle
# copy:
unbind -t vi-copy Enter
bind-key -n -t vi-copy Enter copy-pipe "xclip -i -sel p -f | xclip -i -sel c "
# paste:
unbind ]
bind-key ] run "xclip -o | tmux load-buffer - ; tmux paste-buffer"
