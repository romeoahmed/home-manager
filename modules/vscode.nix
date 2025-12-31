{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-marketplace; [
        # Chinese (Simplified) Language Pack
        ms-ceintl.vscode-language-pack-zh-hans

        # GitHub Copilot Chat
        github.copilot-chat

        # Python
        ms-python.python

        # Rust
        rust-lang.rust-analyzer

        # Zig
        ziglang.vscode-zig

        # clangd
        llvm-vs-code-extensions.vscode-clangd

        # LLDB DAP
        llvm-vs-code-extensions.lldb-dap

        # CMake Tools
        ms-vscode.cmake-tools

        # ESLint
        dbaeumer.vscode-eslint

        # Stylelint
        stylelint.vscode-stylelint

        # Prettier
        esbenp.prettier-vscode

        # TOML
        tamasfe.even-better-toml

        # Markdown
        davidanson.vscode-markdownlint

        # Material Icon Theme
        pkief.material-icon-theme

        # GitHub Actions
        github.vscode-github-actions
      ];

      userSettings = {
        "editor.fontSize" = 16;
        "editor.fontFamily" = "'JetBrains Mono', 'Noto Sans CJK SC'";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'JetBrainsMonoNL Nerd Font'";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };
}
