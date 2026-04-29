
{ config, pkgs, lib, ... }:


{
  programs = {
    firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "de"
        "fr"
        "zh-CN"
      ];
      policies = {
        AppAutoUpdate                 = false;
        BackgroundAppUpdate           = false;
        DisableFirefoxStudies         = true;
        DisableFirefoxAccounts        = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport          = true;
        DisableProfileRefresh         = true;
        DisableSetDesktopBackground   = true;
        DisablePocket                 = true;
        DisableTelemetry              = true;
        NoDefaultBookmarks            = true;
        SearchEngines = {
          Default = "DuckDuckGo";
          PreventInstalls = true;
        };
        SkipTermsOfUse                = true;
        OverrideFirstRunPage          = "";
        OverridePostUpdatePage        = "";
        GenerativeAI.Enabled          = false;
        Homepage                      = "previous-session";

        # Extensions
        ExtensionSettings = let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in {
          "uBlock0@raymondhill.net" = {
            install_url       = moz "ublock-origin";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "navbar";
          };
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = moz "privacy-badger17";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "navbar";
          };
          "jid1-ZAdIEUB7XOzOJw@jetpack" = {
            install_url = moz "duckduckgo-for-firefox";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "navbar";
          };
          "jid1-BoFifL9Vbdl2zQ@jetpack" = {
            install_url = moz "decentraleyes";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "menupanel";
          };
          "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
            install_url = moz "i-dont-care-about-cookies";
            installation_mode = "normal_installed";
            private_browsing  = false;
            default_area      = "menupanel";
          };
          "{9076cefe-e6f8-4883-a480-9f968bd09249}" = {
            install_url = moz "reddit-nsfw-unblocker";
            installation_mode = "normal_installed";
            private_browsing  = false;
            default_area      = "menupanel";
          };
          "{c7a839e7-7086-4021-8176-1cfcb7f169ce}" = {
            install_url = moz "soundcloud-dl";
            installation_mode = "normal_installed";
            private_browsing  = false;
            default_area      = "menupanel";
          };
          "{floccus@handmadeideas.org}" = {
            install_url = moz "floccus";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "menupanel";
          };
          "{ncpasswords@mdns.eu}" = {
            install_url = moz "nextcloud-passwords";
            installation_mode = "normal_installed";
            private_browsing  = true;
            default_area      = "navbar";
          };
        };
      };
    };
  };
}
