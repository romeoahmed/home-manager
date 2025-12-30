{ pkgs, inputs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting
    '';

    plugins = [
      {
        name = "catppuccin/fish";
        src = inputs.fish-catppuccin;
      }
      {
        name = "jorgebucaran/replay.fish";
        src = inputs.fish-replay;
      }
    ];
  };
}
