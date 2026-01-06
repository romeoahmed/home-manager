{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    unzip
    wl-clipboard-rs

    nano
    most
    tokei

    pv
  ];
}
