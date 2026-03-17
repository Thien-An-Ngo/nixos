{ pkgs, ... }:

{
  # libvirtd / QEMU / KVM virtualisation stack
  # Phase 3 from windows VM spec

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;   # TPM 2.0 for Windows 11
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  programs.virt-manager.enable = true;

  # Looking Glass KVMFR shared-memory kernel module
  boot.extraModulePackages = with pkgs.linuxPackages_latest; [
    kvmfr
  ];

  # Load kvmfr at boot and expose /dev/kvmfr0 with correct permissions
  boot.kernelModules = [ "kvmfr" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="thienan", GROUP="kvm", MODE="0660"
  '';

  # Add thienan to the groups required for virtualisation
  users.users.thienan.extraGroups = [ "libvirtd" "kvm" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice-vdagent
    win-virtio     # VirtIO drivers ISO for Windows guests
  ];
}
