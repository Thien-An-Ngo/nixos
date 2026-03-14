{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.zen-browser.packages.x86_64-linux.default
  ];

  #home.file."zen/_/chrome/userChrome.css".source = ./userChrome.css
  #home.file."zen/_/chrome/userContent.css".source = ./userContent.css
}
