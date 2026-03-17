# Windows Gaming VM Spec
## NixOS VFIO/QEMU/KVM + Looking Glass

---

## Host System

| Component | Details |
|---|---|
| **Distro** | NixOS (unstable channel) |
| **CPU** | AMD Ryzen 7 9800X3D (8 cores, 16 threads, single CCD with 3D V-Cache) |
| **RAM** | 64GB DDR5 |
| **Storage** | 7TB NVMe SSD |
| **Host GPU** | AMD Radeon 890M (integrated, in CPU — runs Linux desktop) |
| **Guest GPU** | AMD RX 9070 XT Gigabyte Aorus Ice Stealth (passed through to VM) |
| **Display** | 300Hz monitor |
| **OS** | NixOS with Hyprland on Wayland |
| **Config location** | `/home/thienan/nixos-config` (symlinked to `/etc/nixos`) |

---

## Config Structure

```
/home/thienan/nixos-config/
├── flake.nix
├── configuration.nix
├── hardware-configuration.nix
└── modules/
    ├── system/
    │   ├── boot.nix         ← add iommu params here
    │   ├── gpu.nix          ← AMD host GPU config
    │   ├── audio.nix        ← Pipewire
    │   ├── network.nix
    │   ├── greetd.nix
    │   ├── hyprland.nix
    │   ├── docker.nix
    │   ├── vfio.nix         ← TO CREATE: GPU passthrough
    │   └── vm.nix           ← TO CREATE: libvirtd/QEMU
    └── home/
        ├── default.nix
        ├── hyprland.nix
        ├── packages.nix     ← add looking-glass-client here
        └── ...
```

---

## Nix Style Conventions

- All modules use `{ pkgs, ... }:` or `{ inputs, pkgs, ... }:` function signature
- System modules imported in `configuration.nix` under `imports = []`
- Home manager modules imported in `modules/home/default.nix`
- Hostname is `nixos`, username is `thienan`
- Flake uses `nixos-unstable` channel
- No `let` blocks unless necessary, keep modules flat and readable
- Comments with `#` to explain non-obvious options

---

## Goal

Set up a Windows 11 VM with:
- RX 9070 XT passed through via VFIO at boot
- Looking Glass for in-desktop display (no second monitor needed)
- Near bare-metal GPU performance for gaming
- Vanguard-compatible (League of Legends)
- Optimized for 300Hz display and low input latency

---

## Phase 1 — IOMMU + Boot

**File:** `modules/system/boot.nix`

Add to existing `boot.kernelParams`:
```
"amd_iommu=on"
"iommu=pt"
```

After rebuild + reboot, verify IOMMU groups are working.
The RX 9070 XT and its HDMI audio device must be in their own isolated IOMMU group.

---

## Phase 2 — VFIO Binding

**File:** `modules/system/vfio.nix` (CREATE)

Requirements:
- Load vfio kernel modules early in initrd: `vfio`, `vfio_iommu_type1`, `vfio_pci`, `vfio_virqfd`
- Bind RX 9070 XT PCI IDs to vfio-pci at boot via `vfio-pci.ids=` kernel param
- PCI IDs will be determined after IOMMU check (format: `xxxx:xxxx,xxxx:xxxx` for GPU + audio)
- Add `isolcpus=2-7` `nohz_full=2-7` `rcu_nocbs=2-7` for CPU isolation
- Hugepages: `hugepagesz=1G` `hugepages=32` (32GB for VM)
- `transparent_hugepage=never`
- Set `vm.nr_hugepages = 32` via `boot.kernel.sysctl`

---

## Phase 3 — Virtualisation Stack

**File:** `modules/system/vm.nix` (CREATE)

Requirements:
- `virtualisation.libvirtd.enable = true`
- QEMU package: `pkgs.qemu_kvm`
- `qemu.runAsRoot = true`
- `qemu.swtpm.enable = true` (TPM 2.0 for Windows 11)
- OVMF/UEFI: `qemu.ovmf.enable = true` with `pkgs.OVMFFull.fd`
- `programs.virt-manager.enable = true`
- Add `thienan` to groups: `libvirtd`, `kvm`
- System packages to add: `virt-manager`, `virt-viewer`, `spice-vdagent`, `win-virtio`
- Looking Glass KVMFR kernel module via `boot.extraModulePackages`

---

## Phase 4 — Looking Glass

**File:** `modules/home/packages.nix`

Add to `home.packages`:
- `looking-glass-client`

**Config file:** `~/.config/looking-glass/client.ini`

Managed via `home.file.".config/looking-glass/client.ini"` in a new HM module:

```ini
[app]
allowDMA=yes

[wayland]
framerateMin=300

[input]
grabKeyboard=yes
grabKeyboardOnFocus=yes
rawMouse=yes

[renderer]
vsync=no
```

---

## Phase 5 — CPU Pinning

VM XML configuration for optimal 9800X3D performance:
- Give VM cores 2-7 (6 dedicated cores from the X3D CCD)
- Host keeps cores 0-1
- emulatorpin to cores 0-1
- Memory backed with hugepages, nosharepages, locked

```xml
<vcpu placement="static">6</vcpu>
<cputune>
  <vcpupin vcpu="0" cpuset="2"/>
  <vcpupin vcpu="1" cpuset="3"/>
  <vcpupin vcpu="2" cpuset="4"/>
  <vcpupin vcpu="3" cpuset="5"/>
  <vcpupin vcpu="4" cpuset="6"/>
  <vcpupin vcpu="5" cpuset="7"/>
  <emulatorpin cpuset="0-1"/>
</cputune>
<memoryBacking>
  <hugepages/>
  <nosharepages/>
  <locked/>
  <access mode="shared"/>
</memoryBacking>
```

---

## Phase 6 — Windows VM Setup (manual steps, not Nix)

1. Download Windows 11 ISO
2. Download VirtIO drivers ISO from Fedora
3. Create VM in virt-manager:
   - UEFI/OVMF firmware
   - TPM 2.0 (swtpm)
   - 16-32GB RAM (hugepages backed)
   - 500GB storage on NVMe
   - Add PCI device: RX 9070 XT (GPU)
   - Add PCI device: RX 9070 XT HDMI Audio
   - Add Looking Glass shared memory device
4. Install Windows 11
5. Install VirtIO drivers inside Windows
6. Install AMD Adrenalin drivers for RX 9070 XT
7. Set display to 300Hz in Windows
8. Enable MSI interrupts for GPU
9. Install League of Legends

---

## Post-Install Windows Optimizations

Run in admin PowerShell inside VM:
```powershell
# Disable dynamic tick for lower latency
bcdedit /set useplatformtick yes
bcdedit /set disabledynamictick yes

# High performance power plan
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```

In AMD Adrenalin:
- Set refresh rate explicitly to 300Hz
- Enable Enhanced Sync instead of vsync

---

## Important Notes

- **Do not** touch `hardware-configuration.nix`
- **Do not** modify existing working modules unless necessary for VM setup
- PCI IDs for the RX 9070 XT are unknown until IOMMU check is run — leave as placeholders `REPLACE_GPU_ID` and `REPLACE_AUDIO_ID` until confirmed
- The host iGPU (Radeon 890M) must remain available to Linux at all times — never bind it to vfio
- `boot.nix` already has `quiet` and `splash` kernel params — append, don't replace
- Rebuild command: `sudo nixos-rebuild switch --flake .#nixos`
- Test before committing: `sudo nixos-rebuild test --flake .#nixos`
- Always `git add -A && git commit` before rebuilding

---

## Verification Commands

```bash
# Check IOMMU is enabled
dmesg | grep -i iommu

# List IOMMU groups
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  printf 'IOMMU Group %s ' "$n"
  lspci -nns "${d##*/}"
done

# Check GPU is bound to vfio (after phase 2)
lspci -nnk | grep -A3 "9070"

# Check hugepages
grep Huge /proc/meminfo

# Check libvirtd is running
systemctl status libvirtd

# Check Looking Glass KVMFR module
lsmod | grep kvmfr
```
