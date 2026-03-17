{ pkgs, ... }:

{
  # AMD GPU drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      rocmPackages.clr.icd
      vulkan-validation-layers
    ];

  };

  # Use Mesa/RADV Vulkan driver
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # CoreCtrl — GPU/CPU control GUI (fan curves, power profiles, OC)
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  # Gamemode — auto performance mode when gaming
  programs.gamemode.enable = true;

  # GPU monitoring + gaming tools
  environment.systemPackages = with pkgs; [
    vulkan-tools
    radeontop
    mangohud
    nvtopPackages.amd
  ];
}
