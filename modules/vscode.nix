{ pkgs, inputs, ... }:

let
  marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = [
        # Chinese (Simplified) Language Pack
        marketplace.ms-ceintl.vscode-language-pack-zh-hans

        # GitHub Copilot Chat
        marketplace.github.copilot-chat

        # Python
        marketplace.ms-python.python

        # Rust
        marketplace.rust-lang.rust-analyzer

        # Zig
        marketplace.ziglang.vscode-zig

        # clangd
        marketplace.llvm-vs-code-extensions.vscode-clangd

        # LLDB DAP
        marketplace.llvm-vs-code-extensions.lldb-dap

        # CMake Tools
        marketplace.ms-vscode.cmake-tools

        # ESLint
        marketplace.dbaeumer.vscode-eslint

        # Stylelint
        marketplace.stylelint.vscode-stylelint

        # Prettier
        marketplace.esbenp.prettier-vscode

        # TOML
        marketplace.tamasfe.even-better-toml

        # Markdown
        marketplace.davidanson.vscode-markdownlint

        # Material Icon Theme
        marketplace.pkief.material-icon-theme

        # GitHub Actions
        marketplace.github.vscode-github-actions
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
