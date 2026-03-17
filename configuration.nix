{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/gpu.nix
    ./modules/system/audio.nix
    ./modules/system/network.nix
    ./modules/system/greetd.nix
    ./modules/system/hyprland.nix
    ./modules/system/docker.nix
    ./modules/system/vfio.nix
    ./modules/system/vm.nix
    ./modules/system/keyd.nix
  ];

  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
  };

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Timezone and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";



  # User
  users.users = {
    thienan = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "corectrl" ];
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/secrets/thienan-password";
    };
  }; 

  # Enable zsh system-wide
  programs = {
    zsh.enable = true;
    steam.enable = true;
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    neovim
    vim
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    material-symbols
  ];

  system.stateVersion = "24.11";
}
