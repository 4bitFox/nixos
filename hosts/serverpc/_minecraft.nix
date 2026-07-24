
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
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft ${pkgs.bash}/bin/bash -c "${pkgs.jdk21}/bin/java -Xms2048M -Xmx16384M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=40 -XX:G1ReservePercent=10 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:G1HeapRegionSize=8M -jar ./paper-*.jar nogui"
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft; do
            sleep 1
          done
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft -p 0 -X stuff "stop\r" || true
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft; do
            sleep 1
          done
        '';
        RestartSec = 5;
        Restart = "always";
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
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft_b173 ${pkgs.bash}/bin/bash -c "${pkgs.jdk8}/bin/java -Xms2048M -Xmx16384M -jar poseidon-craftbukkit*.jar nogui"
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft_b173; do
            sleep 1
          done
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft_b173 -p 0 -X stuff "stop\r" || true
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft_b173; do
            sleep 1
          done
        '';
        Environment = "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin";
        RestartSec = 5;
        Restart = "always";
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
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft_b173_viaproxy ${pkgs.bash}/bin/bash -c "${pkgs.jdk21}/bin/java -jar ViaProxy*.jar config viaproxy.yml"
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft_b173_viaproxy; do
            sleep 1
          done
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft_b173_viaproxy -p 0 -X stuff "stop\r" || true
          while ${pkgs.screen}/bin/screen -list | grep -q minecraft_b173_viaproxy; do
            sleep 1
          done
        '';
        Restart = "always";
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
        minecraftserver-console-minecraft = "sudo -u minecraftuser screen -r minecraft";
        minecraftserver-log-minecraft = "cat /data/minecraft/logs/latest.log";
        minecraftserver-console-minecraft_b173 = "sudo -u minecraftuser screen -r minecraft_b173";
        minecraftserver-log-minecraft_b173 = "cat /data/minecraft_b173/server.log";
        minecraftserver-console-minecraft_b173_viaproxy = "sudo -u minecraftuser screen -r minecraft_b173_viaproxy";
        minecraftserver-log-minecraft_b173_viaproxy = "cat /data/minecraft_b173/ViaProxy/logs/latest.log";
      };
    };
  };
}
