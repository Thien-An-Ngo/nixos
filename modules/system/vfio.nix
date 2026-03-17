{ ... }:

{
  # IOMMU + VFIO GPU passthrough for Windows gaming VM
  # Phase 1 + 2 from windows VM spec

  boot.kernelParams = [
    # Enable AMD IOMMU for PCI passthrough
    "amd_iommu=on"
    "iommu=pt"

    # Bind RX 9070 XT (GPU + HDMI audio) to vfio-pci at boot.
    # Replace these placeholders after running the IOMMU group check:
    #   for d in /sys/kernel/iommu_groups/*/devices/*; do
    #     n=${d#*/iommu_groups/*}; n=${n%%/*}
    #     printf 'IOMMU Group %s ' "$n"; lspci -nns "${d##*/}"
    #   done
    "vfio-pci.ids=REPLACE_GPU_ID,REPLACE_AUDIO_ID"

    # CPU isolation — keep cores 0-1 for host, give cores 2-7 (+ SMT siblings 10-15) to VM
    "isolcpus=2-7,10-15"
    "nohz_full=2-7,10-15"
    "rcu_nocbs=2-7,10-15"

    # 1GB hugepages — 32 pages = 32GB reserved for VM
    "hugepagesz=1G"
    "hugepages=32"
    "transparent_hugepage=never"
  ];

  # Load VFIO kernel modules before anything else touches the GPU
  boot.initrd.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];

  # Reserve hugepages in the kernel
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 32;
  };
}
