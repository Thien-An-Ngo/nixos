{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      setw -g clock-mode-style 24
      set -g renumber-windows on
      setw -g pane-base-index 1

      # Splits
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window      -c "#{pane_current_path}"
      bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"

      # ── Kanagawa Dragon status bar ──────────────────────────────────
      set -g status on
      set -g status-position top
      set -g status-style         "bg=#181616"
      set -g status-left-length   40
      set -g status-right-length  80

      # Left: session name capsule (crimson)
      set -g status-left "#[bg=#b5293e,fg=#0d0c0c,bold] #{session_name} #[bg=#181616,fg=#b5293e] "

      # Window tabs
      set -g window-status-style          "fg=#737c73 bg=#181616"
      set -g window-status-current-style  "fg=#c5c9c5 bg=#181616 bold"
      set -g window-status-format         " #I #W "
      set -g window-status-current-format "#[fg=#7d1128,bg=#181616]#[bg=#7d1128,fg=#c5c9c5,bold] #I #W #[bg=#181616,fg=#7d1128]"

      # Right: time + date (dragonBlue capsule)
      set -g status-right "#[fg=#7e9cd8]#[bg=#7e9cd8,fg=#0d0c0c,bold] %H:%M #[fg=#2d2b26,bg=#7e9cd8]#[bg=#2d2b26,fg=#c5c9c5] %d %b "

      # Pane borders
      set -g pane-border-style        "fg=#2d2b26"
      set -g pane-active-border-style "fg=#b5293e"
    '';
  };
}
