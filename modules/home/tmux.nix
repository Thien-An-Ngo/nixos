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

      # ── Blood Vow status bar ──────────────────────────────────────────────────
      set -g status on
      set -g status-position top
      set -g status-style         "bg=#171819"
      set -g status-left-length   40
      set -g status-right-length  80

      # Left: session name capsule (deep rose)
      set -g status-left          "#[bg=#A85070,fg=#171819,bold] #{session_name} #[bg=#171819,fg=#A85070] "

      # Window tabs
      set -g window-status-style          "fg=#4E5254 bg=#171819"
      set -g window-status-current-style  "fg=#C8B8BC bg=#171819 bold"
      set -g window-status-format         " #I #W "
      set -g window-status-current-format "#[fg=#5A1010,bg=#171819]#[bg=#5A1010,fg=#C8B8BC,bold] #I #W #[bg=#171819,fg=#5A1010]"

      # Right: time + date (muted blue capsule)
      set -g status-right         "#[fg=#7BAABF]#[bg=#7BAABF,fg=#171819,bold] %H:%M #[fg=#272A2C,bg=#7BAABF]#[bg=#272A2C,fg=#C8B8BC] %d %b "

      # Pane borders
      set -g pane-border-style        "fg=#272A2C"
      set -g pane-active-border-style "fg=#A85070"
    '';
  };
}
