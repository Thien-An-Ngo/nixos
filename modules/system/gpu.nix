{ pkgs, ... }:

{
  # AMD GPU drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      rocmPackages.clr.icd
    ];
  };

  # Use Mesa
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
}
