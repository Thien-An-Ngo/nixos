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

    # Calculator
    libqalculate

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

    # Keychain & secrets
    bitwarden-desktop
    bitwarden-cli
    seahorse

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
    betterdiscordctl
    spotify
    spicetify-cli
    ani-cli

    # System info
    fastfetch
    macchina

    # Fun terminal toys
    nyancat
    cbonsai
    asciiquarium
    mapscii
    aalib        # includes aafire — run: aafire
    astroterm

    # TUI utilities
    gotop        # graphical activity monitor (gtop equivalent)
    rmpc         # MPD music client with album art (kitty image protocol)
    dysk         # disk usage overview
    pastel       # terminal color tool

    # Audio visualizers
    cava
    cavalier

    # Screen recorder
    kooha

    # Local file sharing
    localsend

    # Terminal clock
    peaclock

    # Animated wallpapers via Wallpaper Engine workshop content
    linux-wallpaperengine

    # System monitor
    mission-center

    # Misc
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
 ];
}
