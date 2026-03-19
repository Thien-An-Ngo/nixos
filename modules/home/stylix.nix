{ pkgs, ... }:

{
  stylix = {
    enable = true;
    enableReleaseChecks = false;  # release-25.05 on nixos-unstable 26.05, intentional
    base16Scheme = ../../themes/blood-vow.yaml;
    polarity = "dark";

    # Solid color wallpaper (animated wallpaper via linux-wallpaperengine overrides at runtime)
    image = pkgs.runCommand "dark-wine-wallpaper" { buildInputs = [ pkgs.imagemagick ]; } ''
      convert -size 3840x2160 xc:'#171819' PNG:$out
    '';

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = { package = pkgs.noto-fonts; name = "Noto Sans"; };
      serif     = { package = pkgs.noto-fonts; name = "Noto Serif"; };
      sizes = {
        terminal     = 14;
        applications = 11;
        desktop      = 11;
        popups       = 11;
      };
    };

    targets = {
      neovim.enable    = false;  # managed via mkOutOfStoreSymlink, not nix
      tmux.enable      = false;  # manual colors in extraConfig
      hyprlock.enable  = false;  # manual colors in hyprland.nix
      rofi.enable      = false;  # custom rasi in anyrun.nix
      starship.enable  = false;  # manual blood_vow palette in zsh.nix (named color slots)
      spicetify.enable = false;  # not configured via nix
    };
  };
}
