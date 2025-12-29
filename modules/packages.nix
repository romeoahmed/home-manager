{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style

    ripgrep
    fd
    bat
    eza

    btop
    fastfetch

    tokei
  ];
}
