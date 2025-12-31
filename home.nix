_:

{
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
