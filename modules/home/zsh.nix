{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "sudo" "copypath" "dirhistory" ];
    };

    initContent = ''
      eval "$(zoxide init zsh)"

      # Aliases
      alias ls="eza --icons"
      alias ll="eza -la --icons"
      alias lt="eza --tree --icons"
      alias cat="bat"
      alias grep="rp"
      alias cd="z"
      alias top="btm"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$cmd_duration"
        "$nodejs"
        "$python"
        "$character"
      ];
      add_newline = true;

      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };

      directory = {
        format = "[ $path ]($style)";
        style = "bg:#1e1e2e fg:#cdd6f4";
        symbol = " ";
      };

      git_branch = {
        format = "[ $symbol$branch ]($style)";
        style = "bg:#313244 fg:#cba6f7";
        symbol = " ";
      };

      git_status = {
        format = "[ $all_status$ahead_behind ]($style)";
        style = "bg:#313244 fg:#f38ba8";
        symbol = " ";
      };

      cmd_duration = {
        format = "[ $duration ]($style)";
        style = "bg:#45475a fg:#f9e2af";
        symbol = " ";
      };

      nodejs = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#313244 fg:#a6e3a1";
        symbol = " ";
      };

      python = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#313244 fg:#a6e3a1";
        symbol = " ";
      };
    };
  };
}
