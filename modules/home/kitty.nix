{ lib, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family	= "JetBrainsMono Nerd Font";
      font_size		= "14.0";
      bold_font		= "auto";
      italic_font 	= "auto";
      bold_italic_font 	= "auto";

      window_padding_width = 12;
      hide_window_decorations = "yes";
      background_opacity = lib.mkForce "0.78";
      dynamic_background_opacity = "yes";
      # Request compositor blur through the window background
      background_blur = 64;

      cursor_shape = "beam";
      cursor_blink_interval = "0.75";

      scrollback_lines = 10000;
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      notify_on_cmd_finish = "unfocused 45.0 notify";

      # Tabs
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_font_style = "bold";
    };

    # No extra keybinds needed — handled globally by keyd (see modules/system/keyd.nix)
  };
}
