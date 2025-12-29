{ pkgs, ... }:

{
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      inter
    ];

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";

    defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" "Noto Sans CJK SC" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        monospace = [ "JetBrainsMonoNL Nerd Font" "Noto Sans Mono CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
    };
  };
}
