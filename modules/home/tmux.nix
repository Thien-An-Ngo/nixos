{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
    historyLimit = 10000;
    mouse = true;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "slanted"
          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_date_time_text "%H:%M %d.%m"
        '';
      }
    ];

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      # Status bar at top so shell doesn't stick to it
      set -g status-position top
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_session}#{E:@catppuccin_status_date_time}"
      set -g status-right-length 100

      # Splits
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"
    '';
  };
}
