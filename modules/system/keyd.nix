{ ... }:

{
  # keyd — kernel-level key remapping, works globally on Wayland/X11
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # Alt+Left/Right — word by word (passed through; handled by apps natively)
          # Alt+Backspace/Delete — delete word
          "alt+backspace" = "C-backspace";
          "alt+delete"    = "C-delete";

          # Ctrl+Left/Right — beginning/end of line
          "control+left"  = "home";
          "control+right" = "end";

          # Ctrl+Up/Down — top/bottom of file
          "control+up"   = "C-home";
          "control+down" = "C-end";
        };
      };
    };
  };
}
