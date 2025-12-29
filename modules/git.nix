{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    signing = {
      key = "8C5095EF11EA485A";
      signByDefault = true;
    };

    settings = {
      init = {
        defaultBranch = "main";
      };

      user = {
        name = "romeoahmed";
        email = "ahmedorqwn@gmail.com";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
