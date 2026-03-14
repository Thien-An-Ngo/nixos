{ inputs, pkgs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./packages.nix
    ./zsh.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./theme.nix
    ./hyprland.nix
    ./caelestia.nix
    ./zen.nix
  ];

  home = {
    username = "thienan";
    homeDirectory = "/home/thienan";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
