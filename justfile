default:
    @just --list

alias b := build
alias u := update
alias s := switch
alias fmt := format

format:
    nix fmt

check:
    nix flake check --all-systems

update:
    nix flake update

clean:
    nh clean user

clean-all:
    sudo nh clean all

init host="nixos":
    sudo nixos-rebuild boot --flake .#{{ host }}

build host="nixos":
    nh os build . -H {{ host }}

switch host="nixos":
    nh os switch . -H {{ host }}
