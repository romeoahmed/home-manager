_:

{
  imports = [
    # ./modules/fonts.nix
    # ./modules/inputMethod.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/git.nix
    ./modules/fish.nix
    # ./modules/alacritty.nix
    # ./modules/vscode.nix
  ];

  home = {
    username = "victor";
    homeDirectory = "/home/victor";
    stateVersion = "25.11";

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
