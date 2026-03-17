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
        # Wallpaper Engine — separate wallpaper per monitor
        # DP-2: CROWNED City Rain (main, right, 300Hz)
        "linux-wallpaperengine --screen-root DP-2 3161563267"
        # DP-4: Cherry Blossom at Night 4K (left, 60Hz)
        "linux-wallpaperengine --screen-root DP-4 2970670204"
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
          size = 12;
          passes = 4;
          noise = "0.02";       # frosted glass texture
          brightness = 0.85;    # slight depth darkening
          xray = false;
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

        # Kitty — let hyprland blur compound with kitty's own background_opacity
        "opacity = 0.96 0.88, match:class = ^(kitty)$"

        # Zen browser opacity
        "opacity = 0.9 0.85, match:class = ^(zen)$"

        # Fix for some Electron apps
        "no_initial_focus = yes, match:class = ^(discord)$"

      ];

      # Layer rules
      layerrule = [
        "blur on, match:namespace = caelestia"
        "blur on, match:namespace = gtk-layer-shell"
#        "ignorezero = on, match:namespace = caelestia"
      ];
    };
  };

  # Hyprlock — adapted from end-4/dots-hyprland, Catppuccin Mocha
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
        blur_passes = 3;
        blur_size = 8;
        brightness = 0.65;
        contrast = 0.9;
        vibrancy = 0.1;
        vibrancy_darkness = 0.3;
      }];

      input-field = [{
        monitor = "";
        size = "250, 50";
        outline_thickness = 2;
        dots_size = 0.1;
        dots_spacing = 0.3;
        dots_center = true;
        outer_color = "rgba(b5293e55)";    # crimson, semi-transparent
        inner_color = "rgba(1d1c1933)";   # Dragon surface, low alpha
        font_color = "rgba(c5c9c5ff)";    # Dragon text
        check_color = "rgba(8a9a7bff)";   # Dragon green
        fail_color = "rgba(c4746eff)";    # Dragon red
        fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
        capslock_color = "rgba(b98d7bff)"; # Dragon peach
        fade_on_empty = true;
        rounding = 10;
        placeholder_text = ''<span foreground="##737c73"><i>Password</i></span>'';
        font_family = "JetBrainsMono Nerd Font";
        position = "0, 20";
        halign = "center";
        valign = "center";
      }];

      label = [
        # Clock
        {
          monitor = "";
          text = "$TIME";
          font_size = 65;
          font_family = "JetBrainsMono Nerd Font Bold";
          color = "rgba(dcd7baff)";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = ''cmd[update:5000] date +"%A, %B %d"'';
          font_size = 17;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(b5293eff)";   # crimson
          position = "0, 240";
          halign = "center";
          valign = "center";
        }
        # User
        {
          monitor = "";
          text = " thienan";
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(dcd7baff)";
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
        # Caps lock warning
        {
          monitor = "";
          text = "cmd[update:250] ~/.config/hypr/hyprlock/check-capslock.sh";
          font_size = 13;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(ffa066ff)";
          position = "0, -25";
          halign = "center";
          valign = "center";
        }
        # Keyboard layout
        {
          monitor = "";
          text = "$LAYOUT";
          font_size = 14;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgba(727169ff)";
          position = "-30, 30";
          halign = "right";
          valign = "bottom";
        }
      ];
    };
  };

  # Hyprlock helper scripts
  home.file.".config/hypr/hyprlock/check-capslock.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      CAPS=$(hyprctl devices | grep -B 6 "main: yes" | grep "capsLock" | head -1 | awk '{print $2}')
      [ "$CAPS" = "yes" ] && echo "󰪛 Caps Lock" || echo ""
    '';
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
