{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [
    pkgs.caelestia-shell
    inputs.caelestia-cli.packages.${system}.default
    pkgs.caelestia-shell.passthru.extras
  ];

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
