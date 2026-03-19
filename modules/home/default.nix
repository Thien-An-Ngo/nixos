{ inputs, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./theme.nix
    ./hyprland.nix
    ./caelestia.nix
    ./zen.nix
    ./nvim.nix
    ./anyrun.nix
    ./looking-glass.nix
    ./stylix.nix
  ];

  home = {
    username = "thienan";
    homeDirectory = "/home/thienan";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
