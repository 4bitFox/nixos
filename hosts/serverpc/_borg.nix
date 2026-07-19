
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
            "/data/mariadb/mysql"
            "/data/samba/share/.recycle"
            "/data/nextcloud/nextcloud/data/*/files_trashbin"
            "/data/nextcloud/nextcloud/data/*/files_versions"
            "**/.cache"
            "**/cache"
            "**/.DS_Store"
            "**/Thumbs.db"
            "**/desktop.ini"
            "**/.AppleDouble"
            "**/.Spotlight-V100"
            "**/.Trashes"
            "**/__MACOSX"
            "**/*.tmp"
            "**/*~"
            "**/~*"
          ];
          prune.keep = {
            within = "1d";
            daily = 7;
            weekly = 4;
            monthly = 12;
          };
          doInit = true;
          compression = "auto,zstd,22";
          startAt = [];
          # startAt = "daily";
          removableDevice = true;
          encryption.mode = "none";
          appendFailedSuffix = true;
        };
      };
    };
  };
  
  systemd.services = {
    mariadb-dump = {
      description = "Dump MariaDB databases for Borg backup";
      after = [ "mariadb.service" ];
      requires = [ "mariadb.service" ];
      serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.mariadb}/bin/mariadb-dump \
          --all-databases \
          --single-transaction \
          --routines \
          --events \
          --triggers \
          --hex-blob \
          > /data/mariadb/db_dump.sql'
      '';
      };
    };
    
    borgbackup-job-data = {
      unitConfig.ConditionPathIsMountPoint = "/backup";
      after = [
        "mariadb-dump.service"
      ];
      requires = [
        "mariadb-dump.service"
      ];
    };
  };

  programs = {
    bash = {
      shellAliases = {
        borgbackup-data-startbackup = "sudo systemctl start borgbackup-job-data.service";
        borgbackup-data-status = "journalctl -fu borgbackup-job-data.service";
      };
    };
  };
}
