{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    prefix = "C-r";
    keyMode = "vi";
    terminal = "screen-256color";
    mouse = true;

    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set -g base-index 1
      set -g repeat-time 1000

      # Status bar — uwunicorn palette, clean minimal
      set -g status-style "bg=#241b26,fg=#eed5d9"
      set -g status-left "#[bg=#2f2a3f,fg=#c965bf,bold]  #S  #[bg=#241b26,fg=#46354a] │ "
      set -g status-left-length 40
      set -g status-right "#[fg=#46354a]│ #[fg=#7e5f83] %H:%M  #[fg=#46354a]│ #[fg=#7e5f83]%a %-d %b  "
      set -g status-right-length 40
      set -g status-justify left

      set -g window-status-format " #[fg=#7e5f83]#I #W "
      set -g window-status-current-format " #[fg=#c965bf,bold]● #I #W "
      set -g window-status-separator ""

      # Pane borders
      set -g pane-border-style "fg=#2f2a3f"
      set -g pane-active-border-style "fg=#6c3cb2"

      # Messages / prompts
      set -g message-style "bg=#2f2a3f,fg=#eed5d9"
      set -g message-command-style "bg=#2f2a3f,fg=#eed5d9"

      # Copy mode / selection
      set -g mode-style "bg=#6c3cb2,fg=#eed5d9"

      # Display panes overlay
      set -g display-panes-colour "#7e5f83"
      set -g display-panes-active-colour "#c965bf"

      # Clock mode
      set -g clock-mode-colour "#c965bf"

      # Pane navigation
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Window navigation by number (create new window if index doesn't exist)
      bind -n M-1 run-shell "tmux select-window -t :1 2>/dev/null || tmux new-window"
      bind -n M-2 run-shell "tmux select-window -t :2 2>/dev/null || tmux new-window"
      bind -n M-3 run-shell "tmux select-window -t :3 2>/dev/null || tmux new-window"
      bind -n M-4 run-shell "tmux select-window -t :4 2>/dev/null || tmux new-window"
      bind -n M-5 run-shell "tmux select-window -t :5 2>/dev/null || tmux new-window"
      bind -n M-6 run-shell "tmux select-window -t :6 2>/dev/null || tmux new-window"
      bind -n M-7 run-shell "tmux select-window -t :7 2>/dev/null || tmux new-window"
      bind -n M-8 run-shell "tmux select-window -t :8 2>/dev/null || tmux new-window"
      bind -n M-9 run-shell "tmux select-window -t :9 2>/dev/null || tmux new-window"
      bind -n M-0 run-shell "tmux select-window -t :10 2>/dev/null || tmux new-window"

      # Window navigation prev/next
      bind -n M-H previous-window
      bind -n M-L next-window

      # Session navigation
      bind -n M-J switch-client -n
      bind -n M-K switch-client -p

      # Kill pane / window
      bind -n M-x kill-pane
      bind -n M-X kill-window

      # Window management
      bind -n M-c new-window -c "#{pane_current_path}"
      bind -n M-, command-prompt -I "#W" "rename-window '%%'"
      bind -n M-$ command-prompt -I "#S" "rename-session '%%'"

      # Splits (stay in current dir)
      bind -n M-n split-window -v -c "#{pane_current_path}"
      bind -n M-v split-window -h -c "#{pane_current_path}"

      # Floating windows
      bind -n M-e display-popup -E -w 80% -h 80% "nnn"
      bind -n M-t display-popup -E -w 80% -h 80% "htop"

      # Resize panes (hold down)
      bind -n -r M-Up    resize-pane -U 2
      bind -n -r M-Down  resize-pane -D 2
      bind -n -r M-Left  resize-pane -L 2
      bind -n -r M-Right resize-pane -R 2

      # Mark and join panes
      bind -n M-m select-pane -m
      bind -n M-b join-pane

      # Zoom / fullscreen
      bind -n M-z resize-pane -Z
      bind -n M-f resize-pane -Z

      # Cycle panes (useful with main-vertical layout)
      bind -n M-O select-pane -t :.+

      # FZF session picker
      bind C-j display-popup -E -w 60% -h 40% \
        "tmux list-sessions -F '#{session_name}' | fzf | xargs tmux switch-client -t"

      # FZF session:window picker
      bind C-k display-popup -E -w 60% -h 40% \
        "tmux list-windows -a -F '#{session_name}:#{window_index} [#{window_name}]' | fzf | awk '{print $1}' | xargs tmux switch-client -t"

      # Main-vertical layout (1 main pane + stacked column on right)
      bind M-4 select-layout main-vertical

      # Vim/nvim pane picker — shows all panes running vim or nvim
      bind C-v display-popup -E -w 70% -h 50% \
        "tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}' | grep -iE '(n?vim)' | fzf | awk '{print $1}' | xargs -I{} tmux switch-client -t {}"
    '';
  };
}
