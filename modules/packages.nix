{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    aria2

    nil
    nixfmt-rfc-style

    vim
    nano

    ripgrep
    fd
    bat
    eza

    btop
    fastfetch

    tokei
  ];
}
