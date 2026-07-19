
{ config, pkgs, lib, ... }:


{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];

  services = {
    borgbackup = {
      jobs = {
        data = {
          repo = "/backup/borg/data";
          paths = [
            "/data"
          ];
          exclude = [
            "/data/*"
          ];
          doInit = true;
          compression = "zstd,3";
          startAt = [];
          # startAt = "daily";
          removableDevice = true;
          encryption.mode = "none";
        };
      };
    };
  };
  
  systemd.services.borgbackup-job-data = {
    unitConfig.ConditionPathIsMountPoint = "/backup";
  };
}
