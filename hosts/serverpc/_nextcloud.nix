
{ config, pkgs, lib, ... }:


{
  services = {
    nextcloud = {
      enable = true;
      hostName = "localhost";
      config.adminpassFile = "/data/nextcloud/admin-secret.txt";
      config.dbtype = "sqlite";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) 
        news contacts calendar tasks bookmarks end_to_end_encryption forms impersonate mail maps notes onlyoffice spreed
        twofactor_admin twofactor_webauthn
        ;
      };
      extraAppsEnable = true;
      maxUploadSize = "1000G";
    };
  };
}
