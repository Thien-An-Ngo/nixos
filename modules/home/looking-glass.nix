{ pkgs, ... }:

{
  home.packages = [ pkgs.looking-glass-client ];

  # Looking Glass client config — optimised for 300Hz, low latency, Wayland
  home.file.".config/looking-glass/client.ini".text = ''
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
  '';
}
