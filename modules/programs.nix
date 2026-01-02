{ pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      package = pkgs.nh;
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
      package = pkgs.helix;
      defaultEditor = true;
      settings.theme = "catppuccin_macchiato";
    };
  };
}
