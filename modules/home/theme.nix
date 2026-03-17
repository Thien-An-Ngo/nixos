{ pkgs, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    tmux.enable = false;
  };

    # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    font = {
      name = "Noto Sans";
      size = 11;
      package = pkgs.noto-fonts;
    };
    gtk3.extraConfig.gtk-key-theme-name = "Emacs";
    gtk4.extraConfig.gtk-key-theme-name = "Emacs";
  };

  # Cursor
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
