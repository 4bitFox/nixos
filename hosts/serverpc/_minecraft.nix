
{ config, pkgs, lib, ... }:


{
  systemd.services = {
    minecraft-server = {
      description = "Minecraft Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "minecraftuser";
        Group = "minecraftgroup";
        WorkingDirectory = "/data/minecraft";
        KillSignal = "SIGINT";
        TimeoutStopSec = "180s";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk21}/bin/java -Xms2048M -Xmx16384M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=40 -XX:G1ReservePercent=10 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:G1HeapRegionSize=8M -jar ./paper-*.jar nogui"
        '';
#        Restart = "unless-stopped";
#        RestartSec = 5;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    25565 # proxy
    25566 # paper
    25567 # poseidon
  ];

  users = {
    groups = {
      minecraftgroup = {
        gid = 3000;
      };
    };
    users = {
      minecraftuser = {
        isSystemUser = true;
        home = "/var/empty";
        createHome = false;
        shell = "${pkgs.shadow}/bin/nologin";
        uid = 3000;
        group = "minecraftgroup";
      };
    };
  };
  
  programs = {
    bash = {
      shellAliases = {
        minecraftserver-status-minecraft = "journalctl -fu minecraft-server.service";
      };
    };
  };
}
