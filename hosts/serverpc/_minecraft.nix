
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
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk21}/bin/java -Xms2048M -Xmx16384M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=40 -XX:G1ReservePercent=10 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:G1HeapRegionSize=8M -jar ./paper-*.jar nogui"
        '';
        Restart = "always";
        RestartSec = 5;
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
        KillSignal = "SIGINT";
        TimeoutStopSec = "180s";
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.screen}/bin/screen -DmS minecraft_b173 ${pkgs.jdk8}/bin/java -Xms2048M -Xmx16384M -jar poseidon-craftbukkit*.jar nogui
#          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk8}/bin/java -Xms2048M -Xmx16384M -Djline.terminal=jline.UnsupportedTerminal -Dterminal.jline=false -Dterminal.ansi=false -jar poseidon-craftbukkit*.jar nogui"
        '';
        ExecStop = ''
          ${pkgs.screen}/bin/screen -S minecraft_b173 -p 0 -X stuff "stop^M"
        '';
        Restart = "always";
        RestartSec = 5;
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
        KillSignal = "SIGINT";
        TimeoutStopSec = "180s";
        SuccessExitStatus = "130";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "exec ${pkgs.jdk8}/bin/java -jar ViaProxy*.jar config viaproxy.yml"
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
#        home = "/var/empty";
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
        minecraftserver-console-minecraft_b173 = "sudo -u minecraftuser screen -r minecraft_b173";
        minecraftserver-status-minecraft_b173_viaproxy = "journalctl -fu minecraft_b173_viaproxy-server.service";
      };
    };
  };
}
