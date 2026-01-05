{ config, ... }:

{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;

      bashrcExtra = ''
        if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} && ''${SHLVL} == 1 ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION='''
          exec fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
      generateCompletions = true;
    };

    nushell.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconfig";

      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    fd.enable = true;
    ripgrep.enable = true;
    bat.enable = true;

    eza = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = false;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    htop.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    aria2.enable = true;

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };
}
