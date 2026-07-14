
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
      };
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
}
