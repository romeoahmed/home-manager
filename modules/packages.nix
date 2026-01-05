{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    unzip
    wl-clipboard-rs

    vim
    nano
    most

    pv

    tokei
  ];
}
