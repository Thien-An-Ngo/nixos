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

  Architecture

  Single-host NixOS flake configuration for hostname nixos (user: thienan, Europe/Berlin).

  Flake Inputs

  - nixpkgs: nixos-unstable
  - home-manager: follows nixpkgs
  - caelestia-shell: custom shell/launcher overlay
  - zen-browser: Zen Browser package
  - catppuccin: Catppuccin theming library

  Module Structure

  configuration.nix — NixOS system entry point. Imports all modules/system/ modules; configures user account,
  fonts, and system packages.

  modules/system/ — System-level NixOS modules:
  - boot.nix — systemd-boot EFI, latest kernel, quiet splash
  - gpu.nix — AMDGPU driver, Mesa, ROCm, RADV Vulkan
  - audio.nix — Pipewire with ALSA/Pulse/JACK compat
  - network.nix — NetworkManager, firewall
  - greetd.nix — tuigreet login manager for Wayland
  - hyprland.nix — Hyprland WM, XDG portal, Polkit, GNOME Keyring, Wayland env vars
  - docker.nix — Docker daemon, auto-prune

  modules/home/ — Home-manager modules (all imported via default.nix):
  - packages.nix — CLI tools, dev tools (Node 22, Bun, Pyenv, Python 3.12), GUI apps
  - zsh.nix — Zsh, oh-my-zsh, fzf, zoxide, starship prompt
  - git.nix — Git config with delta diff viewer
  - tmux.nix — tmux, vi-mode, C-a prefix
  - kitty.nix — Kitty terminal, JetBrainsMono 14pt
  - hyprland.nix — Hyprland keybindings, Hyprlock, Hypridle
  - theme.nix — Catppuccin Mocha/Mauve, Papirus icons, GTK/Qt
  - caelestia.nix — caelestia-shell as systemd user service
  - zen.nix — Zen Browser from flake input

  Key Conventions

  - All theming: Catppuccin Mocha flavor, Mauve accent
  - Wayland-first; Hyprland env vars set in modules/system/hyprland.nix
  - Flake inputs passed as specialArgs so any module can reference them
  - User password hash: /etc/nixos/secrets/thienan-password
  - NixOS state version: 24.11

  Overlay Pattern for Flake Inputs

  `nixpkgs.overlays` defined inside `nixosSystem` modules only affects the pkgs
  available within the NixOS system evaluation. Flake inputs that use
  `inputs.nixpkgs.follows = "nixpkgs"` still evaluate their packages against
  `nixpkgs.legacyPackages`, which is NOT overlaid.

  To patch a dependency of a flake input package, use `.override {}` directly on
  the flake package in the overlay:

  ```nix
  (final: prev: {
    caelestia-shell = (caelestia-shell.packages.${system}.with-cli).override {
      someDep = prev.someDep;  # inject our pkgs version instead of theirs
    };
  })
  ```

  Hardware

  Dual monitor setup (both 2560x1440):
  - DP-4: Eizo EV2795 — left monitor, 60Hz, position 0x0
  - DP-2: Lenovo 27Q-11 — right monitor (main), 300Hz, position 2560x0

  Installing Packages

  - User apps (Discord, Spotify, etc.): add to `home.packages` in `modules/home/packages.nix`
  - Steam: must be enabled at system level via `programs.steam.enable = true` in
    `configuration.nix` (needs 32-bit lib support wired in by the NixOS module)
  - Search for package names: `nix search nixpkgs <name>`

  Known Workarounds

  - caelestia-shell: upstream `nix/app2unit.nix` pins app2unit to v1.0.3 via
    `overrideAttrs`, but inherits nixpkgs' `postFixup` (designed for v1.3.0) which
    tries to substitute a pattern no longer present in 1.0.3, causing a build failure.
    Fixed in flake.nix by overriding `app2unit = prev.app2unit` (nixpkgs 1.3.0)
    on the caelestia-shell package directly.

  - Hyprland 0.54+ layerrule blur syntax: `blur` in layerrules now requires an explicit
    value — use `"blur on, <target>"` not `"blur, <target>"`. The old syntax produces
    "invalid field blur: missing a value" at startup.

