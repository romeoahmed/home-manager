{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    aria2
    unzip
    wl-clipboard

    nixd
    nixfmt-rfc-style

    vim
    nano
    most

    ripgrep
    fd
    bat
    eza

    pv

    htop
    btop
    fastfetch

    tokei
  ];
}
