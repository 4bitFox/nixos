
{ config, pkgs, lib, ... }:


{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33; # Only ever increment by 1 to update (leaving out a major version is not supported)
      hostName = "nextcloud.tschudibacon.com";
#      https = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) 
        news contacts calendar tasks bookmarks end_to_end_encryption forms impersonate mail maps notes onlyoffice spreed
        twofactor_admin twofactor_webauthn
        ;
      };
      extraAppsEnable = true;
      appstoreEnable = false;
      maxUploadSize = "1000G";
      database.createLocally = true;
      config = {
        adminuser = "admin";
        adminpassFile = "/data/nextcloud/admin-secret.txt";
        dbtype = "mysql";
        dbhost = "localhost";
        dbname = "nextcloud";
        dbuser = "nextcloud";
      };
      configureRedis = true;
      home = "/data/nextcloud/nextcloud";
      nginx = {
        hstsMaxAge = 15552000;
      };
      settings = {
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        trusted_domains = [
          "nextcloud.tschudibacon.com"
          "localhost"
          "127.0.0.1"
        ];
      };
      phpExtraExtensions = all: [
        all.smbclient
      ];
    };

    nginx = {
      virtualHosts."${config.services.nextcloud.hostName}" = {
        listen = [ { addr = "127.0.0.1"; port = 8080; } ];
#        forceSSL = true;
#        enableACME = true;
      };
    };
  };

#  security.acme = {
#    acceptTerms = true;   
#    certs = { 
#      ${config.services.nextcloud.hostName}.email = "nextcloud-letsencrypt@tschudibacon.com"; 
#    };
#  };

  systemd.services = {
    nextcloud-custom-config = {
      path = [
        config.services.nextcloud.occ
      ];
      script = ''
        nextcloud-occ theming:config name "Tschudibacon!"
        nextcloud-occ theming:config slogan "the crazy stuff"
        nextcloud-occ theming:config url "https://nextcloud.tschudibacon.com";
        nextcloud-occ theming:config primary_color "#8C00CF";
        nextcloud-occ theming:config background_color "#000000";
        nextcloud-occ theming:config logo /data/nextcloud/logo.png;
        nextcloud-occ theming:config favicon /data/nextcloud/favicon.png;
        nextcloud-occ theming:config background /data/nextcloud/background.jpg;
        nextcloud-occ app:enable files_external;
        nextcloud-occ app:enable admin_audit;
        nextcloud-occ app:disable firstrunwizard;
        nextcloud-occ app:disable survey_client;
        nextcloud-occ app:disable user_status;
      after = [ "nextcloud-setup.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
