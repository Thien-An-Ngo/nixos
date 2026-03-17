{ pkgs, ... }:

{
  # Catppuccin module disabled — using Kanagawa Dragon
  catppuccin = {
    enable = false;
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Kanagawa-Dragon-BL";
      package = pkgs.kanagawa-gtk-theme;
    };
    iconTheme = {
      name = "kanagawa-dragon";
      package = pkgs.kanagawa-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
      package = pkgs.noto-fonts;
    };
    gtk3.extraConfig.gtk-key-theme-name = "Emacs";
    gtk4.extraConfig.gtk-key-theme-name = "Emacs";
  };

  # Cursor — keep catppuccin cursor (no kanagawa cursor exists)
  home.pointerCursor = {
    name = "catppuccin-mocha-mauve-cursor";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
