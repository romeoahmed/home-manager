{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      fcitx5-with-addons = pkgs.kdePackages.fcitx5-with-addons;
      addons = with pkgs; [
        fcitx5-rime
      ];

      waylandFrontend = true;

      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "cn";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-cn";
          "Groups/0/Items/1".Name = "rime";
        };

        addons = {
          classicui.globalSection = {
            # 垂直候选列表
            "Vertical Candidate List" = "False";
            # 使用鼠标滚轮翻页
            WheelForPaging = "True";
            # 字体
            Font = "Noto Sans 12";
            # 菜单字体
            MenuFont = "Sans 10";
            # 托盘字体
            TrayFont = "Sans Bold 10";
            # 托盘标签轮廓颜色
            TrayOutlineColor = "#000000";
            # 托盘标签文本颜色
            TrayTextColor = "#ffffff";
            # 优先使用文字图标
            PreferTextIcon = "False";
            # 在图标中显示布局名称
            ShowLayoutNameInIcon = "True";
            # 使用输入法的语言来显示文字
            UseInputMethodLanguageToDisplayText = "True";
            # 主题
            Theme = "plasma";
            # 深色主题
            DarkTheme = "plasma";
            # 跟随系统浅色/深色设置
            UseDarkTheme = "True";
            # 当被主题和桌面支持时使用系统的重点色
            UseAccentColor = "True";
            # 在 X11 上针对不同屏幕使用单独的 DPI
            PerScreenDPI = "False";
            # 固定 Wayland 的字体 DPI
            ForceWaylandDPI = 0;
            # 在 Wayland 下启用分数缩放
            EnableFractionalScale = "True";
          };
        };
      };
    };
  };
}
