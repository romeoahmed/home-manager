_:

{
  imports = [
    ./modules/fonts.nix
    ./modules/inputMethod.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/gnupg.nix
    ./modules/git.nix
    ./modules/alacritty.nix
    ./modules/vscode.nix
    ./modules/zed.nix
    ./modules/catppuccin.nix
    ./modules/firefox.nix
  ];

  home = {
    username = "victor";
    homeDirectory = "/home/victor";
    stateVersion = "26.05";

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  xdg = {
    enable = true;

    portal.config = {
      common = {
        default = [ "kde" ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "Alacritty.desktop"
        ];
      };
    };

    autostart.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
