{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    aria2

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
