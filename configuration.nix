{ inputs, ... }:

{
  system.stateVersion = "26.05";

  wsl = {
    enable = true;
    useWindowsDriver = true;
    defaultUser = "victor";
  };

  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      substituters = [
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Shanghai";
}
