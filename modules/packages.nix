{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fh

    curl
    wget
    aria2
    unzip
    wl-clipboard

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
