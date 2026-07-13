
{ config, pkgs, lib, ... }:


{
  services = {
    mysql = {
      enable = true;
      dataDir = "/data/mariadb/mysql";
      package = pkgs.mariadb;
#      ensureDatabases = [ "nextcloud" ];
#      ensureUsers = [
#        {
#          name = "nextcloud";
#          ensurePermissions = { "nextcloud.*" = "ALL PRIVILEGES";};
#        }
#      ];
    };
  };

  # ensure that the db is running *before* running the nextcloud setup
#  systemd.services."nextcloud-setup" = {
#    requires = ["mysql.service"];
#    after = ["mysql.service"];
#  };
}
