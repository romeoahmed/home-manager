{
  description = "My Nix World";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    systems.url = "github:nix-systems/default";

    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.2";
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

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "https://flakehub.com/f/helix-editor/helix/0.1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
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
            overlays = [
              self.overlays.default
              inputs.rust-overlay.overlays.default
            ];
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
              editorconfig-checker.enable = true;
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
        inherit (inputs.flake-schemas) schemas;

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

        nixosConfigurations = {
          nixos = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              inputs.lix-module.nixosModules.default

              inputs.nix-ld.nixosModules.nix-ld
              { programs.nix-ld.dev.enable = true; }

              inputs.nixos-wsl.nixosModules.default
              ./configuration.nix

              {
                nixpkgs.overlays = [
                  self.overlays.default
                  inputs.rust-overlay.overlays.default
                ];
              }

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.victor = ./home.nix;
                };
              }
            ];
          };
        };
      };
    };
}
