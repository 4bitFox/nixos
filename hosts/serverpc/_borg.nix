
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
          prune.keep = {
            within = "1d"; # Keep all archives from the last day
            daily = 7;
            weekly = 4;
            monthly = -1; # Keep at least one archive for each month
          };
          doInit = true;
          compression = "auto,zstd,5";
          startAt = [];
          # startAt = "daily";
          removableDevice = true;
          encryption.mode = "none";
          appendFailedSuffix = true;
        };
      };
    };
  };
  
  systemd.services.borgbackup-job-data = {
    unitConfig.ConditionPathIsMountPoint = "/backup";
  };
}
