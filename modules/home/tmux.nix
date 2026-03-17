{ pkgs, config, ... }:

{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "/home/thienan/.setup/tmux/tmux.conf";
}
