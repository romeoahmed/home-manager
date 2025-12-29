{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    themePackage = pkgs.alacritty-theme;
    theme = "catppuccin_macchiato";
    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        dynamic_padding = true;
        decorations = "Full";
        opacity = 1.0;
        blur = false;
        startup_mode = "Maximized";
      };

      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMonoNL Nerd Font";
          style = "Regular";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
      };

      terminal = {
        shell = "${pkgs.fish}/bin/fish";
      };
    };
  };
}
