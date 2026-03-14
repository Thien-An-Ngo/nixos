{ pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.kernelParams = [ "quiet" "splash" ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
