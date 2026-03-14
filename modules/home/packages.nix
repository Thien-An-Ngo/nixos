{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Shell utilities
    zoxide
    fzf
    fd
    yazi
    bat
    eza
    ripgrep
    sd
    dust
    bottom
    procs
    delta
    lazygit
    jq
    unzip
    htop
    btop

    # Wayland utilities
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    brightnessctl
    playerctl
    pamixer
    networkmanagerapplet

    # Dev tools
    claude-code
    docker
    poetry
    bruno
    insomnia

    # Dev
    nodejs_22
    bun
    pyenv
    python312
    dbeaver-bin
    usql
    gh
    httpie
    k9s
    lazydocker


    # Apps
    thunar
    mpv
    imv
    pavucontrol
    discord
    spotify

    # Misc
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
 ];
}
