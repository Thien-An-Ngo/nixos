{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [ inputs.anyrun.homeManagerModules.default ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${system}; [
        applications
        rink
      ];
      width.fraction = 0.28;
      position = "top";
      verticalOffset.absolute = 180;
      hidePluginInfo = true;
      closeOnClick = true;
      maxEntries = 6;
    };

    extraCss = ''
      * {
        font-family: "Rubik", sans-serif;
        font-size: 15px;
        transition: 100ms ease;
      }

      #window {
        background: alpha(#1e1e2e, 0.92);
        border: 2px solid #cba6f7;
        border-radius: 16px;
      }

      #plugin, #main {
        background: transparent;
      }

      #entry {
        background: transparent;
        color: #cdd6f4;
        padding: 14px 18px;
        font-size: 18px;
        border: none;
        border-bottom: 1px solid alpha(#cba6f7, 0.25);
        border-radius: 0;
      }

      #entry:focus {
        outline: none;
        box-shadow: none;
      }

      list {
        padding: 8px;
      }

      row {
        border-radius: 10px;
        padding: 6px 10px;
      }

      row:selected, row:hover {
        background: alpha(#cba6f7, 0.18);
      }

      .name {
        color: #cdd6f4;
        font-size: 15px;
      }

      .description {
        color: #a6adc8;
        font-size: 12px;
      }
    '';
  };
}
