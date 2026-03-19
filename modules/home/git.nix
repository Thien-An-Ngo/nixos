{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "thien-an-ngo";
      user.email = "thienan.tianen@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      alias = {
        s = "status";
        l = "log --oneline --graph --decorate";
        ca = "commit --amend";
        undo = "reset HEAD~1 --mixed";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate        = true;
      side-by-side    = true;
      line-numbers    = true;
      syntax-theme    = "base16";
      dark            = true;
    };
  };
}
