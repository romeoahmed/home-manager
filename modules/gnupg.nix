{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;

    settings = {
      keyid-format = "0xlong";
      fixed-list-mode = true;
      with-fingerprint = true;
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "timeout=10";
    };

    publicKeys = [
      {
        # Linus Torvalds
        # Fingerprint ABAF 11C6 5A29 70B1 30AB  E3C4 79BE 3E43 0041 1886
        source = ./pubkeys/torvalds.asc;
        trust = "full";
      }
      {
        # Greg Kroah-Hartman
        # Fingerprint 	647F 2865 4894 E3BD 4571  99BE 38DB BDC8 6092 693E
        source = ./pubkeys/gregkh.asc;
        trust = "full";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;

    enableSshSupport = true;
    sshKeys = [ "CCC243C1A35F6C658D0FBD78A853F5837B1C8678" ];

    pinentry.package = pkgs.pinentry-qt;
  };
}
