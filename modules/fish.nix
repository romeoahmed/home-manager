{ pkgs, inputs, ... }:

{
  programs.fish = {
    enable = true;

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
