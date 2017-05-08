# retangle mode
bind-key -T copy-mode-vi v send-keys -X rectangle-toggle
# copy:
unbind -T copy-mode-vi Enter
bind-key -n -T copy-mode-vi Enter send-keys -X copy-pipe "xclip -i -sel p -f | xclip -i -sel c "
# paste:
unbind ]
bind-key ] run "xclip -o | tmux load-buffer - ; tmux paste-buffer"
