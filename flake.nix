{
  description = "Home Manager configuration of victor";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    rime-wanxiang = {
      url = "github:amzxyz/rime_wanxiang";
      flake = false;
    };

    fish-replay = {
      url = "github:jorgebucaran/replay.fish";
      flake = false;
    };
    fish-catppuccin = {
      url = "github:catppuccin/fish";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."victor" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          ./modules/fonts.nix
          ./modules/inputMethod.nix
          ./modules/packages.nix
          ./modules/programs.nix
          ./modules/git.nix
          ./modules/fish.nix
          ./modules/alacritty.nix
          ./modules/vscode.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
