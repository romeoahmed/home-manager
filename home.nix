_:

{
  imports = [
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/gnupg.nix
    ./modules/git.nix
  ];

  home = {
    username = "victor";
    homeDirectory = "/home/victor";
    stateVersion = "26.05";

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
