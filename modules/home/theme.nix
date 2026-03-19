{ pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    # font and theme/iconTheme are owned by stylix
    gtk3.extraConfig.gtk-key-theme-name = "Emacs";
    gtk4.extraConfig.gtk-key-theme-name = "Emacs";
  };

  # Set a neutral cursor (stylix doesn't manage cursors directly)
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "kvantum";
    # style.name left to stylix — it generates a kvantum theme automatically
  };
}
