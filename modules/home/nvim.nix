{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    gcc        # tree-sitter parser compilation
    tree-sitter
    ripgrep    # telescope live_grep
    fd         # telescope file finder
    gnumake    # telescope-fzf-native compilation
    vimPlugins.markdown-preview-nvim  # pre-built md preview server
  ];

  # Symlink the live nvim config directory so edits take effect immediately
  # without rebuilding. Clone the repo first:
  #   git clone git@github.com:thien-an-ngo/nvim.git ~/nvim
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/thienan/.setup/nvim";
}
