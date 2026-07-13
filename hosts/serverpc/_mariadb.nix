
{ config, pkgs, lib, ... }:


{
  services = {
    mysql = {
      enable = true;
      dataDir = "/data/mariadb/mysql";
    };
  };
}
