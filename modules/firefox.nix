{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    languagePacks = [
      "en-US"
      "zh-CN"
    ];

    nativeMessagingHosts = with pkgs; [
      kdePackages.plasma-browser-integration
    ];

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SuspectedFingerprinting = true;
        Category = "strict";
        BaselineExceptions = true;
        ConvenienceExceptions = true;
      };

      HttpsOnlyMode = "enabled";

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          default_area = "navbar";
          private_browsing = true;
        };
        "CanvasBlocker@kkapsner.de" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
          private_browsing = true;
        };
        "plasma-browser-integration@kde.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
          private_browsing = true;
        };
        "firefox@tampermonkey.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
          default_area = "navbar";
        };
        "wappalyzer@crunchlabz.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi";
          default_area = "navbar";
        };
      };

      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = {
          Value = 1;
          Status = "locked";
        };

        "media.peerconnection.ice.proxy_only_if_behind_proxy" = {
          Value = true;
          Status = "locked";
        };
        "media.peerconnection.ice.default_address_only" = {
          Value = true;
          Status = "locked";
        };

        "network.dns.disablePrefetch" = {
          Value = true;
          Status = "locked";
        };
        "network.dns.disablePrefetchFromHTTPS" = {
          Value = true;
          Status = "locked";
        };
        "network.prefetch-next" = {
          Value = false;
          Status = "locked";
        };

        "network.cookie.cookieBehavior" = {
          Value = 5;
          Status = "locked";
        };
      };
    };
  };
}
