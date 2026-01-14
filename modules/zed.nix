{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "git-firefly"
      "html"
      "toml"
      "make"
      "fish"
      "catppuccin"
      "catppuccin-icons"
    ];

    extraPackages = with pkgs; [
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ];
      })

      nixd
      nixfmt
      clang-tools
      basedpyright
    ];

    mutableUserSettings = true;

    userSettings = {
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 16;
      buffer_font_features = {
        calt = true;
      };
      buffer_font_fallbacks = [ "Noto Sans CJK SC" ];

      features = {
        edit_prediction_provider = "zed";
      };

      terminal = {
        font_family = "JetBrainsMonoNL Nerd Font";
        font_size = 14;
        shell = {
          program = "fish";
        };
      };

      lsp = {
        nixd = {
          settings = {
            diagnostic = {
              suppress = [ "sema-extra-with" ];
            };
          };
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
    };
  };
}
