{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "catppuccin/fish";
        src = pkgs.fish-plugins.catppuccin;
      }
      {
        name = "jorgebucaran/replay.fish";
        src = pkgs.fish-plugins.replay;
      }
    ];
  };
}
