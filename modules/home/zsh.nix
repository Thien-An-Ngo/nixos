{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "sudo" "copypath" "dirhistory" "docker" "gh" ];
    };

    initContent = ''
      eval "$(zoxide init zsh)"

      # Alt+Left/Right — word navigation in terminal (keyd passes these through)
      bindkey '\e[1;3D' backward-word
      bindkey '\e[1;3C' forward-word

      # Completions for tools not covered by oh-my-zsh plugins
      if command -v k9s &>/dev/null; then source <(k9s completion zsh); fi
      if command -v poetry &>/dev/null; then source <(poetry completions zsh); fi
      if command -v bun &>/dev/null; then
        # Lazy-load bun completions to avoid _tags errors at shell startup
        function _bun() {
          unfunction _bun
          eval "$(bun completions 2>/dev/null)"
          _bun "$@"
        }
        compdef _bun bun
      fi

      # Play sound when long commands finish (>45s)
      __cmd_start=0
      function _cmd_timer_preexec() { __cmd_start=$SECONDS }
      function _cmd_timer_precmd() {
        local elapsed=$(( SECONDS - __cmd_start ))
        if (( __cmd_start > 0 && elapsed >= 45 )); then
          paplay /run/current-system/sw/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
        fi
        __cmd_start=0
      }
      add-zsh-hook preexec _cmd_timer_preexec
      add-zsh-hook precmd _cmd_timer_precmd

      # Aliases
      alias ls="eza --icons"
      alias ll="eza -la --icons"
      alias lt="eza --tree --icons"
      alias cat="bat"
      alias grep="rg"
      alias cd="z"
      alias top="btm"

      # NixOS
      alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos#nixos"
      alias rebuild-log="sudo nixos-rebuild switch --flake /etc/nixos#nixos 2>&1 | tee /tmp/rebuild.log"
      alias nixup="nix flake update /etc/nixos && rebuild"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 10000;

      format = lib.concatStrings [
        "[](red)"
        "$os"
        "$username"
        "[](bg:peach fg:red)"
        "$directory"
        "[](bg:yellow fg:peach)"
        "$git_branch"
        "$git_status"
        "[](fg:yellow bg:green)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "[](fg:green bg:sapphire)"
        "$conda"
        "[](fg:sapphire bg:lavender)"
        "$time"
        "[ ](fg:lavender)"
        "$line_break"
        "$character"
      ];

      right_format = "$cmd_duration";

      palette = "blood_vow";

      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:crust";
        style_root = "bg:red fg:crust";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:peach fg:crust";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = "  ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
      };

      git_status = {
        style = "bg:yellow";
        format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version)(\\($virtualenv\\)) ](fg:crust bg:green)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:sapphire";
        format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
      };

      conda = {
        symbol = "  ";
        style = "fg:crust bg:sapphire";
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:lavender";
        format = "[[  $time ](fg:crust bg:lavender)]($style)";
      };

      line_break.disabled = true;

      character = {
        disabled = false;
        success_symbol = "[➜](bold fg:green)";
        error_symbol = "[➜](bold fg:red)";
        vimcmd_symbol = "[←](bold fg:green)";
        vimcmd_replace_one_symbol = "[←](bold fg:lavender)";
        vimcmd_replace_symbol = "[←](bold fg:lavender)";
        vimcmd_visual_symbol = "[←](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        min_time = 0;
        format = "[ $duration](bold red) ";
        disabled = false;
      };


      palettes.blood_vow = {
        red = "#A85070";       # base0E deep rose — first segment, error indicator
        peach = "#C07840";     # base09 copper — directory
        yellow = "#C4A35A";    # base0A muted gold — git
        green = "#7BAABF";     # base0B muted blue — languages
        sapphire = "#9A7A9C";  # base0D muted purple — docker/conda
        lavender = "#E8A0B0";  # base0C sakura — time
        crust = "#171819";     # base00 — dark fg on colored segments
        text = "#C8B8BC";      # base05
        subtext1 = "#DCCDD0";  # base06
        subtext0 = "#8C7880";  # base04
        overlay2 = "#4E5254";  # base03
        surface0 = "#171819";  # base00
      };
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      inline_height = 16;
      show_preview = true;
      enter_accept = true;
    };
  };
}
