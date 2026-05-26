#!/bin/sh

inactive_style='fg=#7a809b,bg=default'
active_style='default'

# Walk every pane across all sessions and apply a pane-local style. This avoids
# using a global window-style that can dim the active pane too.
tmux list-panes -a -F '#{pane_id} #{pane_active}' |
while IFS=' ' read -r pane active; do
  [ -n "$pane" ] || continue

  if [ "$active" = "1" ]; then
    # Reset the active pane so apps keep their original colors.
    tmux set-option -q -p -t "$pane" window-style "$active_style"
  else
    # Muted foreground for inactive panes; background stays transparent/default.
    tmux set-option -q -p -t "$pane" window-style "$inactive_style"
  fi
done
