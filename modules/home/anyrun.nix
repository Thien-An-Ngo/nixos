{ pkgs, lib, ... }:

let
  rofiZoxide = pkgs.writeShellScriptBin "rofi-zoxide" ''
    if [[ -n "$*" ]]; then
      dir="$*"
      zoxide add "$dir" 2>/dev/null
      ${pkgs.thunar}/bin/thunar "$dir" &
    else
      ${pkgs.zoxide}/bin/zoxide query -l 2>/dev/null
    fi
  '';
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc ];
    font = "Rubik 14";
    terminal = "kitty";
    extraConfig = {
      modi = "drun,calc,zoxide:${rofiZoxide}/bin/rofi-zoxide";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "";
      icon-theme = "Papirus-Dark";
      kb-cancel = "Escape";
      kb-accept-alt = "";
      kb-row-tab = "";
      kb-element-next = "";
      kb-element-prev = "";
      kb-mode-next = "Tab";
      kb-mode-previous = "Shift+Tab";
      click-to-exit = true;
    };
    theme = lib.mkForce (builtins.toFile "blood-vow.rasi" ''
      * {
        bg:      #171819;
        surface: #1F2022;
        overlay: #272A2C;
        text:    #C8B8BC;
        subtext: #8C7880;
        accent:  #5A1010;

        background-color: transparent;
        text-color:       @text;
        font:             "Rubik 14";
      }

      window {
        background-color: @bg;
        border:           2px solid;
        border-color:     @accent;
        border-radius:    16px;
        width:            680px;
        padding:          0;
      }

      mainbox {
        background-color: transparent;
        children:         [ inputbar, listview ];
        spacing:          0;
      }

      inputbar {
        background-color: transparent;
        border-radius:    16px 16px 0 0;
        padding:          14px 18px;
        border:           0 0 1px 0;
        border-color:     @overlay;
        children:         [ prompt, entry ];
        spacing:          8px;
      }

      prompt {
        background-color: transparent;
        text-color:       @accent;
        vertical-align:   0.5;
      }

      entry {
        background-color: transparent;
        text-color:       @text;
        placeholder:      "Search...";
        placeholder-color: @subtext;
        vertical-align:   0.5;
        font:             "Rubik 18";
      }

      listview {
        background-color: transparent;
        padding:          8px;
        lines:            6;
        scrollbar:        false;
        spacing:          2px;
      }

      element {
        background-color: transparent;
        border-radius:    10px;
        padding:          8px 12px;
        spacing:          12px;
        children:         [ element-icon, element-text ];
      }

      element selected {
        background-color: rgba(90, 16, 16, 0.35);
      }

      element-icon {
        background-color: transparent;
        size:             24px;
        vertical-align:   0.5;
      }

      element-text {
        background-color: transparent;
        text-color:       @text;
        vertical-align:   0.5;
      }
    '');
  };
}
