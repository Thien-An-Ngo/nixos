# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Build without switching
sudo nixos-rebuild build --flake /etc/nixos#nixos

# Update all flake inputs
nix flake update /etc/nixos

# Update a single input
nix flake update nixpkgs --flake /etc/nixos

# Check flake outputs
nix flake check /etc/nixos
```

## Architecture

Single-host NixOS flake configuration for hostname `nixos` (user: `thienan`, Europe/Berlin).

### Flake Inputs

- `nixpkgs`: nixos-unstable
- `home-manager`: follows nixpkgs
- `caelestia-shell`: custom shell/launcher overlay
- `zen-browser`: Zen Browser package
- `stylix`: stylix theming framework (release-25.05)

### Module Structure

`configuration.nix` — NixOS system entry point. Imports all `modules/system/` modules; configures user account, fonts, and system packages.

`modules/system/` — System-level NixOS modules:
- `boot.nix` — systemd-boot EFI, latest kernel, quiet splash
- `gpu.nix` — AMDGPU driver, Mesa, ROCm, RADV Vulkan
- `audio.nix` — Pipewire with ALSA/Pulse/JACK compat
- `network.nix` — NetworkManager, firewall
- `greetd.nix` — tuigreet login manager for Wayland
- `hyprland.nix` — Hyprland WM, XDG portal, Polkit, GNOME Keyring, Wayland env vars
- `docker.nix` — Docker daemon, auto-prune

`modules/home/` — Home-manager modules (all imported via `default.nix`):
- `packages.nix` — CLI tools, dev tools (Node 22, Bun, Pyenv, Python 3.12), GUI apps
- `zsh.nix` — Zsh, oh-my-zsh, fzf, zoxide, starship prompt
- `git.nix` — Git config with delta diff viewer
- `tmux.nix` — tmux, vi-mode, C-a prefix
- `kitty.nix` — Kitty terminal, JetBrainsMono 14pt
- `hyprland.nix` — Hyprland keybindings, Hyprlock, Hypridle
- `stylix.nix` — stylix base16 theme config (Blood Vow palette, fonts, disabled targets)
- `theme.nix` — GTK font, Bibata cursor, Qt/kvantum (stylix owns gtk.theme)
- `caelestia.nix` — caelestia-shell as systemd user service
- `zen.nix` — Zen Browser from flake input

## Key Conventions

- All theming: stylix with Blood Vow base16 palette (`themes/blood-vow.yaml`); mahogany (`#5A1010`) is the primary accent color
- Wayland-first; Hyprland env vars set in `modules/system/hyprland.nix`
- Flake inputs passed as `specialArgs` so any module can reference them
- User password hash: `/etc/nixos/secrets/thienan-password`
- NixOS state version: 24.11

## Overlay Pattern for Flake Inputs

`nixpkgs.overlays` defined inside `nixosSystem` modules only affects the `pkgs` available within the NixOS system evaluation. Flake inputs that use `inputs.nixpkgs.follows = "nixpkgs"` still evaluate their packages against `nixpkgs.legacyPackages`, which is NOT overlaid.

To patch a dependency of a flake input package, use `.override {}` directly on the flake package in the overlay:

```nix
(final: prev: {
  caelestia-shell = (caelestia-shell.packages.${system}.with-cli).override {
    someDep = prev.someDep;  # inject our pkgs version instead of theirs
  };
})
```

## Hardware

Dual monitor setup (both 2560x1440):
- `DP-4`: Eizo EV2795 — left monitor, 60Hz, position 0x0
- `DP-2`: Lenovo 27Q-11 — right monitor (main), 300Hz, position 2560x0

## Installing Packages

- User apps (Discord, Spotify, etc.): add to `home.packages` in `modules/home/packages.nix`
- Steam: must be enabled at system level via `programs.steam.enable = true` in `configuration.nix` (needs 32-bit lib support wired in by the NixOS module)
- Search for package names: `nix search nixpkgs <name>`

## Known Workarounds

**caelestia-shell build failure**: upstream `nix/app2unit.nix` pins app2unit to v1.0.3 via `overrideAttrs`, but inherits nixpkgs' `postFixup` (designed for v1.3.0) which tries to substitute a pattern no longer present in 1.0.3. Fixed in `flake.nix` by overriding `app2unit = prev.app2unit` (nixpkgs 1.3.0) on the caelestia-shell package directly.

**Hyprland 0.54+ layerrule syntax**: namespace must be specified as `match:namespace = <value>`. Both bare `"blur, caelestia"` and `"blur on, caelestia"` produce config errors. Correct:
```nix
layerrule = [
  "blur on, match:namespace = caelestia"
  "blur on, match:namespace = gtk-layer-shell"
];
```
Test live with: `hyprctl keyword layerrule "blur on, match:namespace = caelestia"`

**Hyprland 0.54+ windowrule syntax**: `windowrulev2` is deprecated. New flat syntax:
```nix
windowrule = [
  "float = yes, match:class = ^(pavucontrol)$"
  "opacity = 0.92 0.88, match:class = ^(kitty)$"
  "no_initial_focus = yes, match:class = ^(discord)$"
];
```
Note: old `noinitialfocus` rule name → `no_initial_focus`. Block syntax (`windowrule { }`) also supported but requires `extraConfig`.

**tmux status bar uses manual colors** (stylix target disabled): Blood Vow hex colors are hardcoded in `tmux.nix` extraConfig. Powerline glyphs (U+E0B0, U+E0B2) are embedded in the status-left/right/current-format strings — edit with Python, not the Edit tool, to preserve non-ASCII.

**Stylix home-manager wiring**: `stylix.nixosModules.stylix` alone does NOT inject into home-manager. Must explicitly add to `flake.nix`:
```nix
home-manager.sharedModules = [ stylix.homeModules.stylix ];
```
Note: `homeManagerModules` was renamed to `homeModules` in release-25.05.

**Stylix conflicts**: Several home-manager options that stylix also manages need `lib.mkForce` or removal to avoid build errors:
- `qt.platformTheme.name`: use `lib.mkForce "kvantum"` (stylix defaults to "qtct")
- `qt.style.name`: do NOT set — stylix manages this via generated kvantum theme; overriding triggers unsupported warning
- `programs.kitty.settings.background_opacity`: use `lib.mkForce "0.78"`
- `gtk.font`: remove from theme.nix — stylix sets this from `stylix.fonts.sansSerif`
- `programs.starship.settings.palette`: disable via `stylix.targets.starship.enable = false`

**Stylix wallpaper imagemagick**: Output path has no extension so must specify format explicitly:
```nix
convert -size 3840x2160 xc:'#171819' PNG:$out  # NOT: ... $out
```

**Stylix version mismatch**: Using `release-25.05` with nixos-unstable (26.05) produces a warning. Suppressed with `stylix.enableReleaseChecks = false` in `stylix.nix`.
