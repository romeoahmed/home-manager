{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "html"
      "toml"
      "make"
      "fish"
    ];

    extraPackages = with pkgs; [
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ];
      })

      nixd
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

      features = {
        edit_prediction_provider = "zed";
      };

      terminal = {
        font_family = "JetBrainsMonoNL Nerd Font";
        font_size = 14;
        shell = {
          with_arguments = {
            program = "fish";
            args = [ "--login" ];
          };
        };
      };
    };
  };
}
