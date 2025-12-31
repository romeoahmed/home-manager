{
  description = "My Nix World";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    systems.url = "github:nix-systems/default";

    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "https://flakehub.com/f/numtide/treefmt-nix/0.1";
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
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = import inputs.systems;

      perSystem =
        {
          config,
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deadnix.enable = true;
            };
          };

          pre-commit = {
            check.enable = true;
            settings.hooks = {
              treefmt.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            packages =
              with pkgs;
              [
                nixd
              ]
              ++ config.pre-commit.settings.enabledPackages;

            inherit (config.pre-commit) shellHook;
          };
        };

      flake = {
        overlays.default =
          final: _prev:
          let
            inherit (final.stdenv.hostPlatform) system;
          in
          {
            fh = inputs.fh.packages.${system}.default;
            nh = inputs.nh.packages.${system}.default;
            helix = inputs.helix.packages.${system}.default;

            inherit (inputs.nix-vscode-extensions.extensions.${system}) vscode-marketplace;

            inherit (inputs) rime-wanxiang;

            fish-plugins = {
              replay = inputs.fish-replay;
              catppuccin = inputs.fish-catppuccin;
            };
          };

        homeConfigurations."victor" =
          let
            system = "x86_64-linux";
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [ self.overlays.default ];
            };
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

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
          };
      };
    };
}
