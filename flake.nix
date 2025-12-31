{
  description = "Home Manager configuration of victor";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "https://flakehub.com/f/cachix/git-hooks.nix/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0.1";
    nh = {
      url = "https://flakehub.com/f/nix-community/nh/4.2.0-beta5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    helix = {
      url = "https://flakehub.com/f/helix-editor/helix/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    {
      self,
      nixpkgs,
      systems,
      home-manager,
      git-hooks,
      ...
    }@inputs:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [ self.overlays.default ];
            };

            pre-commit-check = git-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
              };
            };
          in
          f { inherit pkgs pre-commit-check; }
        );
    in
    {
      overlays.default = final: prev: {
        fh = inputs.fh.packages.${final.stdenv.hostPlatform.system}.default;
        nh = inputs.nh.packages.${final.stdenv.hostPlatform.system}.default;
        helix = inputs.helix.packages.${final.stdenv.hostPlatform.system}.default;

        inherit (inputs.nix-vscode-extensions.extensions.${final.stdenv.hostPlatform.system})
          vscode-marketplace
          ;

        inherit (inputs) rime-wanxiang;

        fish-plugins = {
          replay = inputs.fish-replay;
          catppuccin = inputs.fish-catppuccin;
        };
      };

      formatter = forEachSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);

      checks = forEachSystem (
        { pre-commit-check, ... }:
        {
          inherit pre-commit-check;
        }
      );

      devShells = forEachSystem (
        { pkgs, pre-commit-check }:
        {
          default = pkgs.mkShellNoCC {
            packages =
              (with pkgs; [
                nixd
              ])
              ++ pre-commit-check.enabledPackages;

            inherit (pre-commit-check) shellHook;
          };
        }
      );

      homeConfigurations."victor" =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

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
