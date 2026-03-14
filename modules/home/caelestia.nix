{ pkgs, ... }:

{
  home.packages = [ pkgs.caelestia-shell ];

  home.file."assets/walls/.keep".text = "";

  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia Shell";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };
    Service ={
      ExecStart = "${pkgs.caelestia-shell}/bin/caelestia-shell";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}
