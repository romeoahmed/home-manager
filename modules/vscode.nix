{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (
      ps: with ps; [
        (rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
        })
        clang-tools
        lldb
        basedpyright
      ]
    );
    mutableExtensionsDir = true;
  };
}
