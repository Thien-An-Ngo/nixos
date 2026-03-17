{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Monitor
      # Format: name, resolution@hz, position, scale
      monitor = [
        "DP-4,2560x1440@60,0x0,1"
        "DP-2,2560x1440@300,2560x0,1"
      ];

      # Autostart
      exec-once = [
#        "caelestia shell -d"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "hypridle"
      ];

      # Input
      input = {
	kb_layout = "us";
	follow_mouse = 1;
	sensitivity = 0;
	touchpad.natural_scroll = true;
      };

      # General
      general = {
	gaps_in = 4;
	gaps_out = 8;
	border_size = 2;
	layout = "dwindle";
	resize_on_border = true;
      };

      # Decoration
      decoration = {
	rounding = 10;
	blur = {
          enabled = true;
          size = 8;
          passes = 3;
#          new_optimizations = true;
          xray = false;
#          ignore_opacity = true;
	};
        active_opacity = 1.0;
        inactive_opacity = 0.85;
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "easeOut, 0.16, 1, 0.3, 1"
          "easeIn, 0.7, 0, 0.84, 0"
          "spring, 0.68, -0.55, 0.265, 1.55"
        ];
        animation = [
          "windows, 1, 4, spring, popin 80%"
          "windowsOut, 1, 3, easeIn, popin 80%"
          "border, 1, 8, default"
          "fade, 1, 4, easeOut"
          "workspaces, 1, 5, easeOut, slidevert"
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
      };

      # Misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
#        animate_manual_resize = true;
      };

      # Keybinds
      # $mod = SUPER key
      "$mod" = "SUPER";

      bind = [
        # Core
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, Space, exec, pgrep rofi && pkill rofi || rofi -show drun"
        "$mod SHIFT, Space, togglefloating"
        "$mod, F, fullscreen, 0"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Caelestia
        "$mod, D, exec, caelestia shell drawers toggle launcher"
        "$mod, E, exec, thunar"
        "$mod SHIFT, S, exec, caelestia screenshot"
        "$mod, L, exec, hyprlock"
        "$mod, V, exec, caelestia clipboard"

        # Screenshots
        ", Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
        "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Wokspaces 1-9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scroll through workspace
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Window rules (new block syntax, windowrulev2 is deprecated)
      windowrule = [
        # Float these apps
        "float = yes, match:class = ^(pavucontrol)$"
        "float = yes, match:class = ^(nm-connection-editor)$"
        "float = yes, match:class = ^(thunar)$, match:title = ^(?!.*Thunar).*$"

        # Kitty opacity
        "opacity = 0.92 0.88, match:class = ^(kitty)$"

        # Zen browser opacity
        "opacity = 0.9 0.85, match:class = ^(zen)$"

        # Fix for some Electron apps
        "no_initial_focus = yes, match:class = ^(discord)$"

        # Close rofi on focus loss
        "stayfocused = yes, match:class = ^(rofi)$"
      ];

      # Layer rules
      layerrule = [
        "blur on, match:namespace = caelestia"
        "blur on, match:namespace = gtk-layer-shell"
#        "ignorezero = on, match:namespace = caelestia"
      ];
    };
  };

  # Hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
      };

      background = [{
        path = "screenshot";
        color = "rgb(1e1e2e)";
        blur_passes = 4;
        blur_size = 7;
        brightness = 0.55;
        contrast = 0.9;
        vibrancy = 0.15;
      }];

      input-field = [{
        size = "280, 56";
        position = "0, -120";
        halign = "center";
        valign = "center";
        outline-thickness = 3;
        placeholder-text = ''<span foreground="##a6adc8"><i> Enter password...</i></span>'';
        hide-input = false;
        rounding = 12;
        outer_color = "rgb(cba6f7)";
        inner_color = "rgb(181825)";
        font_color = "rgb(cdd6f4)";
        check_color = "rgb(a6e3a1)";
        fail_color = "rgb(f38ba8)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "rgb(fab387)";
        fade_on_empty = true;
        font_family = "JetBrainsMono Nerd Font";
      }];

      label = [
        # Clock
        {
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          font_size = 96;
          font_family = "JetBrainsMono Nerd Font Bold";
          color = "rgba(cdd6f4ff)";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          text = ''cmd[update:60000] echo "$(date +"%A, %B %d")"'';
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(cba6f7ff)";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
        # Greeting
        {
          text = "  thienan";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(a6adc8ff)";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        { timeout = 300; on-timeout = "hyprlock"; }
        { timeout = 600; on-timeout = "hyprctl dispatch dpms off";
                         on-resume = "hyprctl dispatch dpms on"; }
      ];
    };
  };
}
