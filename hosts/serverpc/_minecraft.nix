
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
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk21}/bin/java -Xms2048M -Xmx16384M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=40 -XX:G1ReservePercent=10 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:G1HeapRegionSize=8M -jar ./paper-*.jar nogui"
        '';
        RestartSec = 5;
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
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk8}/bin/java -Xms2048M -Xmx16384M -Djline.terminal=jline.UnsupportedTerminal -Dterminal.jline=false -Dterminal.ansi=false -jar poseidon-craftbukkit*.jar nogui"
        '';
        Environment = "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin";
        RestartSec = 5;
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
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk21}/bin/java -jar ViaProxy*.jar config viaproxy.yml"
        '';
        Restart = "no";
        RestartSec = 5;
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
        minecraftserver-journal-minecraft = "journalctl -fu minecraft-server.service";
        minecraftserver-log-minecraft = "cat /data/minecraft/logs/latest.log";
        minecraftserver-journal-minecraft_b173 = "journalctl -fu minecraft_b173-server.service";
        minecraftserver-log-minecraft_b173 = "cat /data/minecraft_b173/server.log";
        minecraftserver-journal-minecraft_b173_viaproxy = "journalctl -fu minecraft_b173_viaproxy-server.service";
        minecraftserver-log-minecraft_b173_viaproxy = "cat /data/minecraft_b173/ViaProxy/logs/latest.log";
      };
    };
  };
}
