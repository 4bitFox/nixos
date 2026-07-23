
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
        TimeoutStopSec = "180s";
        KillMode = "none";
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk21}/bin/java -Xms2048M -Xmx16384M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=40 -XX:G1ReservePercent=10 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:G1HeapRegionSize=8M -jar ./paper-*.jar nogui"
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft -p 0 -X stuff "stop$(printf '\r')"
        '';
        RestartSec = 120;
        Restart = "no";
      };
    };
    minecraft_b173-server = {
      description = "Minecraft Beta 1.7.3 Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "minecraftuser";
        Group = "minecraftgroup";
        WorkingDirectory = "/data/minecraft_b173";
        TimeoutStopSec = "180s";
        KillMode = "none";
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft_b173 ${pkgs.bash}/bin/bash -c "${pkgs.jdk8}/bin/java -Xms2048M -Xmx16384M -jar poseidon-craftbukkit*.jar nogui"
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft_b173 -p 0 -X stuff "stop$(printf '\r')"
        '';
        Environment = "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin";
        RestartSec = 120;
        Restart = "no";
      };
    };
    minecraft_b173_viaproxy-server = {
      description = "Minecraft Beta 1.7.3 Server ViaProxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "minecraftuser";
        Group = "minecraftgroup";
        WorkingDirectory = "/data/minecraft_b173/ViaProxy";
        TimeoutStopSec = "180s";
        KillMode = "none";
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft_b173_viaproxy ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk8}/bin/java -jar ViaProxy*.jar config viaproxy.yml"
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft_b173_viaproxy -p 0 -X stuff "stop$(printf '\r')"
        '';
        Restart = "no";
        RestartSec = 120;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    25565 # minecraft
    35565 # minecraft_b173
    35568 # minecraft_b173_ViaProxy
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
        home = "/run/home/minecraftuser";
        createHome = true;
        shell = "${pkgs.shadow}/bin/nologin";
        uid = 3000;
        group = "minecraftgroup";
      };
    };
  };

  programs = {
    bash = {
      shellAliases = {
        minecraftserver-console-minecraft = "journalctl -fu minecraft-server.service";
        minecraftserver-log-minecraft = "cat /data/minecraft/server.log";
        minecraftserver-console-minecraft_b173 = "sudo -u minecraftuser screen -r minecraft_b173";
        minecraftserver-log-minecraft_b173 = "cat /data/minecraft_b173/server.log";
        minecraftserver-console-minecraft_b173_viaproxy = "journalctl -fu minecraft_b173_viaproxy-server.service";
        minecraftserver-log-minecraft_b173_viaproxy = "cat /data/minecraft_b173/ViaProxy/logs/latest.log";
      };
    };
  };
}
