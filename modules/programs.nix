{ pkgs, ... }:

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

    fish.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/victor/.config/home-manager";

      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
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

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };
}
