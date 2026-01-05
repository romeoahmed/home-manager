{
  description = "My Nix World";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

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
      url = "github:nix-community/home-manager";
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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rime-wanxiang = {
      url = "github:amzxyz/rime_wanxiang";
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
              inputs.zig-overlay.overlays.default
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deadnix.enable = true;
              just.enable = true;
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
                just
                just-lsp
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
            nh = inputs.nh.packages.${system}.default;
            zls = inputs.zls.packages.${system}.default;
            helix = inputs.helix.packages.${system}.default;

            inherit (inputs.nix-vscode-extensions.extensions.${system}) vscode-marketplace;

            inherit (inputs) rime-wanxiang;
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
                  inputs.zig-overlay.overlays.default
                ];
              }

              inputs.catppuccin.nixosModules.catppuccin

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };

                  users.victor = {
                    imports = [
                      ./home.nix
                      inputs.catppuccin.homeModules.catppuccin
                      {
                        catppuccin = {
                          enable = true;
                          flavor = "macchiato";
                        };
                      }
                    ];
                  };
                };
              }
            ];
          };
        };
      };
    };
}
