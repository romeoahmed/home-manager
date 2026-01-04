_:

{
  programs = {
    fish = {
      enable = true;
      generateCompletions = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/victor/.config/home-manager";

      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = false;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };
}
