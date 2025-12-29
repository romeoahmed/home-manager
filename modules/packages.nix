{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    aria2
    unzip
    wl-clipboard

    nil
    nixfmt-rfc-style

    vim
    nano
    most

    ripgrep
    fd
    bat
    eza

    pv

    cmakeMinimal
    ninja

    htop
    btop
    fastfetch

    tokei
  ];
}
