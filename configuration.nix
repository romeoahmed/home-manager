_:

{
  system.stateVersion = "25.05";

  wsl = {
    enable = true;
    defaultUser = "victor";
  };

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://hercules-ci.cachix.org"
        "https://numtide.cachix.org"
        "https://helix.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
}
