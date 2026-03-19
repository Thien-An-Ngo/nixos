# Stylix Theme — Blood Vow (IMPLEMENTED 2026-03-19)

## Overview

Replaced the mixed-theming setup (catppuccin nix module + kanagawa-gtk + catppuccin cursor)
with a single stylix-managed base16 theme: **Blood Vow** — a custom dark mahogany palette.

**Implementation notes / deviations from original plan:**
- Theme renamed from "Dark Wine" → **"Blood Vow"** (user preference)
- Palette file: `/etc/nixos/themes/blood-vow.yaml` (not `dark-wine.yaml`)
- Starship: took **Option A** (renamed palette to `blood_vow` with updated hex values) rather than Option B (stylix-managed), to preserve the existing named color slots used by format strings
- `fail_color` in hyprlock: uses deep rose (`#A85070`, base0E) not mahogany — **mahogany is the primary accent**, not an error color
- `stylix.targets.starship` left at default (not explicitly disabled), palette handled manually in `zsh.nix`

**Current state:**
- `flake.nix` imports `catppuccin` from `github:catppuccin/nix`
- `modules/home/default.nix` imports `inputs.catppuccin.homeModules.catppuccin`
- `modules/home/theme.nix`: catppuccin.enable = false; GTK uses kanagawa-dragon; cursor is catppuccin-mocha-mauve
- `modules/home/git.nix`: delta syntax-theme = "Catppuccin-mocha"
- `modules/home/anyrun.nix`: rofi theme is a hand-written rasi file (no catppuccin dep)
- `modules/home/kitty.nix`: no explicit colors — stylix will handle automatically
- `modules/home/tmux.nix`: programs.tmux with inline Kanagawa Dragon colors in extraConfig
- `modules/home/nvim.nix`: mkOutOfStoreSymlink to ~/.setup/nvim — NOT nix-managed
- `modules/home/zsh.nix`: starship uses inline `kanagawa_dragon` palette
- `modules/home/hyprland.nix`: hyprlock has hardcoded Kanagawa Dragon hex colors

---

## Chosen Palette

| Slot   | Hex       | Role                          |
|--------|-----------|-------------------------------|
| base00 | `#171819` | Main background               |
| base01 | `#1F2022` | Editor bg / gutter            |
| base02 | `#272A2C` | Selection                     |
| base03 | `#4E5254` | Comments                      |
| base04 | `#8C7880` | Dark foreground               |
| base05 | `#C8B8BC` | Main text                     |
| base06 | `#DCCDD0` | Light foreground              |
| base07 | `#EDE3E5` | Headings / bright             |
| base08 | `#5A1010` | Mahogany — accent / errors    |
| base09 | `#C07840` | Copper — numbers              |
| base0A | `#C4A35A` | Muted gold — types / warnings |
| base0B | `#7BAABF` | Muted blue — strings          |
| base0C | `#E8A0B0` | Sakura — special chars        |
| base0D | `#9A7A9C` | Muted purple — functions      |
| base0E | `#A85070` | Deep rose — keywords          |
| base0F | `#6B3545` | Dark wine — deprecated        |

---

## Step 1: Create the base16 YAML theme file

Create `/etc/nixos/themes/dark-wine.yaml`:

```yaml
scheme: "Dark Wine"
author: "thienan"
variant: "dark"
palette:
  base00: "171819"
  base01: "1F2022"
  base02: "272A2C"
  base03: "4E5254"
  base04: "8C7880"
  base05: "C8B8BC"
  base06: "DCCDD0"
  base07: "EDE3E5"
  base08: "5A1010"
  base09: "C07840"
  base0A: "C4A35A"
  base0B: "7BAABF"
  base0C: "E8A0B0"
  base0D: "9A7A9C"
  base0E: "A85070"
  base0F: "6B3545"
```

Note: base16 YAML values are hex strings WITHOUT the `#` prefix.

---

## Step 2: Add stylix to flake.nix

### 2a. Add input

```nix
stylix = {
  url = "github:danth/stylix/release-25.05";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

### 2b. Thread through outputs destructuring

```nix
outputs = { self, nixpkgs, home-manager, caelestia-shell, zen-browser, catppuccin, stylix, ... }@inputs:
```

### 2c. Add stylix NixOS module to nixosSystem modules list

```nix
modules = [
  ./configuration.nix
  stylix.nixosModules.stylix
  { nixpkgs.overlays = [ ... ]; }  # keep caelestia overlay as-is
  home-manager.nixosModules.home-manager
  { ... }  # keep home-manager user config as-is
];
```

Adding `stylix.nixosModules.stylix` here is sufficient — it auto-enables the home-manager module
for all users when home-manager is embedded in NixOS.

---

## Step 3: Create /etc/nixos/modules/home/stylix.nix

```nix
{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = /etc/nixos/themes/dark-wine.yaml;
    polarity = "dark";

    # Solid color wallpaper (animated wallpaper via linux-wallpaperengine overrides at runtime)
    image = pkgs.runCommand "dark-wine-wallpaper" { buildInputs = [ pkgs.imagemagick ]; } ''
      convert -size 3840x2160 xc:'#171819' $out
    '';

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = { package = pkgs.noto-fonts; name = "Noto Sans"; };
      serif     = { package = pkgs.noto-fonts; name = "Noto Serif"; };
      sizes = {
        terminal     = 14;
        applications = 11;
        desktop      = 11;
        popups       = 11;
      };
    };

    targets = {
      neovim.enable   = false;  # managed via mkOutOfStoreSymlink, not nix
      tmux.enable     = false;  # manual colors in extraConfig (see Step 7)
      hyprlock.enable = false;  # manual colors in hyprland.nix (see Step 7)
      rofi.enable     = false;  # custom rasi in anyrun.nix (see Step 7)
      starship.enable = false;  # inline palette in zsh.nix (see Step 7)
      spicetify.enable = false; # not configured via nix
    };
  };
}
```

---

## Step 4: Update modules/home/default.nix

Remove catppuccin import, add stylix.nix:

```nix
imports = [
  # REMOVE: inputs.catppuccin.homeModules.catppuccin
  ./packages.nix
  ./zsh.nix
  ./tmux.nix
  ./kitty.nix
  ./git.nix
  ./theme.nix
  ./hyprland.nix
  ./caelestia.nix
  ./zen.nix
  ./nvim.nix
  ./anyrun.nix
  ./looking-glass.nix
  ./stylix.nix   # ADD
];
```

---

## Step 5: Update modules/home/theme.nix

Remove kanagawa GTK theme, kanagawa icons, catppuccin cursor.
Stylix owns gtk.theme and gtk.iconTheme now. Keep only structural settings:

```nix
{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font = { name = "Noto Sans"; size = 11; package = pkgs.noto-fonts; };
    gtk3.extraConfig.gtk-key-theme-name = "Emacs";
    gtk4.extraConfig.gtk-key-theme-name = "Emacs";
    # DO NOT set gtk.theme or gtk.iconTheme — stylix owns those
  };

  # Set a neutral cursor (stylix doesn't manage cursors directly)
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
```

Remove from packages (if present): `pkgs.kanagawa-gtk-theme`, `pkgs.kanagawa-icon-theme`,
`pkgs.catppuccin-cursors.mochaMauve`.

---

## Step 6: (Optional) Remove catppuccin from flake.nix

Remove catppuccin input block and remove `catppuccin` from outputs destructuring.
Not strictly necessary (catppuccin.enable = false already) but keeps the flake clean.

---

## Step 7: Manual color updates for disabled stylix targets

Use this mapping from old Kanagawa Dragon → new palette when updating files below.

### modules/home/tmux.nix — status bar colors in extraConfig

```
bg=#181616 → bg=#171819  (base00)
bg=#b5293e → bg=#A85070  (base0E deep rose)
fg=#c5c9c5 → fg=#C8B8BC  (base05)
fg=#737c73 → fg=#4E5254  (base03)
bg=#7d1128 → bg=#5A1010  (base08 mahogany)
bg=#7e9cd8 → bg=#7BAABF  (base0B muted blue)
bg=#2d2b26 → bg=#272A2C  (base02)
```

Key status bar lines to produce:

```
set -g status-style         "bg=#171819"
set -g status-left          "#[bg=#A85070,fg=#171819,bold] #{session_name} #[bg=#171819,fg=#A85070] "
set -g window-status-style          "fg=#4E5254 bg=#171819"
set -g window-status-current-style  "fg=#C8B8BC bg=#171819 bold"
set -g window-status-current-format "#[fg=#5A1010,bg=#171819]#[bg=#5A1010,fg=#C8B8BC,bold] #I #W #[bg=#171819,fg=#5A1010]"
set -g status-right         "#[fg=#7BAABF]#[bg=#7BAABF,fg=#171819,bold] %H:%M #[fg=#272A2C,bg=#7BAABF]#[bg=#272A2C,fg=#C8B8BC] %d %b "
set -g pane-border-style        "fg=#272A2C"
set -g pane-active-border-style "fg=#A85070"
```

### modules/home/hyprland.nix — hyprlock colors

```nix
outer_color    = "rgba(A8507055)";  # base0E deep rose, semi-transparent
inner_color    = "rgba(17181933)";  # base00 bg
font_color     = "rgba(C8B8BCff)";  # base05 text
check_color    = "rgba(7BAABFff)";  # base0B muted blue (success)
fail_color     = "rgba(5A1010ff)";  # base08 mahogany (error)
capslock_color = "rgba(C07840ff)";  # base09 copper
# clock label:   "rgba(DCCDd0ff)"  (base06)
# date label:    "rgba(A85070ff)"  (base0E)
```

### modules/home/anyrun.nix — rasi theme colors

```
bg:      #171819  (base00)
surface: #1F2022  (base01)
overlay: #272A2C  (base02)
text:    #C8B8BC  (base05)
subtext: #8C7880  (base04)
accent:  #5A1010  (base08)
selected element bg: rgba(90, 16, 16, 0.35)  (base08 at 35% alpha)
```

### modules/home/git.nix — delta

```nix
syntax-theme = "base16";  # bat theme auto-generated by stylix
```

### modules/home/zsh.nix — starship palette

Replace the `kanagawa_dragon` palette block. Either:
- **Option A**: Rename to `dark_wine` and update all hex values to the new palette
- **Option B**: Enable `stylix.targets.starship = true` in stylix.nix and remove the manual
  palette entirely — stylix will generate starship colors automatically

Option B is cleaner. If taking it, remove `palette = "kanagawa_dragon"` and the
`palettes.kanagawa_dragon = { ... }` block from starship settings in zsh.nix.

---

## Step 8: Apply

```bash
nix flake update /etc/nixos   # fetch stylix into flake.lock
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

Or using the aliases from zsh.nix: `rebuild`

---

## Gotchas

- **Wallpaper**: stylix requires `stylix.image`. Using a solid color PNG generated via
  `runCommand + imagemagick` works as a static fallback — linux-wallpaperengine overrides at runtime.
- **Stylix module location**: `stylix.nixosModules.stylix` in the NixOS modules list is sufficient
  when home-manager is embedded. Do NOT also add a homeManagerModules import — it causes double-loading.
- **catppuccin conflict**: The catppuccin home module is imported in default.nix even though
  `catppuccin.enable = false`. Remove the import line to avoid phantom options.
- **Delta syntax-theme**: "Catppuccin-mocha" will not be installed after removing catppuccin.
  Change to `"base16"` which stylix generates automatically via bat.
- **Qt/kvantum**: Keep `libsForQt5.qtstyleplugin-kvantum` and `qt6Packages.qtstyleplugin-kvantum`
  in packages — stylix uses them for Qt theming.
- **Icon theme**: Stylix does not manage icon themes. Manually set `gtk.iconTheme` in theme.nix
  (e.g. Papirus-Dark) or leave unset for system default.
- **First build**: Fetching stylix for the first time will be slow. Expect a longer rebuild.

---

## File Summary

| Action | File | Change |
|--------|------|--------|
| CREATE | `/etc/nixos/themes/dark-wine.yaml` | New base16 palette YAML |
| CREATE | `/etc/nixos/modules/home/stylix.nix` | New stylix config module |
| MODIFY | `/etc/nixos/flake.nix` | Add stylix input + module; remove catppuccin |
| MODIFY | `/etc/nixos/modules/home/default.nix` | Remove catppuccin import; add `./stylix.nix` |
| MODIFY | `/etc/nixos/modules/home/theme.nix` | Remove kanagawa/catppuccin; keep GTK font + qt |
| MODIFY | `/etc/nixos/modules/home/tmux.nix` | Update status bar hex colors |
| MODIFY | `/etc/nixos/modules/home/hyprland.nix` | Update hyprlock hex colors |
| MODIFY | `/etc/nixos/modules/home/anyrun.nix` | Update rasi hex colors |
| MODIFY | `/etc/nixos/modules/home/git.nix` | Change delta syntax-theme to `"base16"` |
| MODIFY | `/etc/nixos/modules/home/zsh.nix` | Replace starship kanagawa_dragon palette |
| NO TOUCH | `/etc/nixos/modules/home/nvim.nix` | mkOutOfStoreSymlink — stylix target disabled |
| NO TOUCH | `/etc/nixos/modules/home/kitty.nix` | Stylix themes kitty automatically |
| NO TOUCH | `/etc/nixos/modules/home/caelestia.nix` | Caelestia has its own theming |
