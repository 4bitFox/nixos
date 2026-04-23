
{ config, pkgs, lib, impermanence, ... }:


{
  imports = [
    impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist" = { 
    neededForBoot = true;
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/docker"
      "/var/lib/upower"
      "/var/lib/waydroid"
      "/var/lib/ollama"
      "/var/lib/libvirt"
      "/var/lib/flatpak"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/var/lib/cups/printers.conf"
      "/var/lib/logrotate.status"
    ];
  };

  boot = {
    initrd = {
      postDeviceCommands = lib.mkAfter ''
        echo "                                              "
        echo "                                              "
        echo "                                              "
        echo "                          -\$-                 "
        echo "                         .H##H,               "
        echo "                        +######+              "
        echo "                     .+#########H.            "
        echo "                   -\$############@.           "
        echo "                 =H###############@  -X:      "
        echo "               .\$##################:  @#@-    "
        echo "          ,;  .M###################;  H###;   "
        echo "        ;@#:  @###################@  ,#####:  "
        echo "      -M###.  M#################@.  ;######H  "
        echo "      M####-  +###############$   =@#######X  "
        echo "      H####$   -M###########+   :#########M,  "
        echo "       /####X-   =########%   :M########@/.   "
        echo "         ,;%H@X;   .\$###X   :##MM@%+;:-       "
        echo "                      ..                      "
        echo "       -/;:-,.              ,,-==+M########H  "
        echo "      -##################@HX%%+%%$%%%+:,,     "
        echo "         .-/H%%%+%%\$H@###############M@+=:/+: "
        echo "     /XHX%:#####MH%=    ,---:;;;;/&&XHM,:###$ "
        echo "     \$@#MX %+;-                               "
        echo "                                              "
        echo "                                              "
        echo "                                              "
        echo "DELETING ROOT..."
        mkdir /mnt
        mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt
        btrfs subvolume delete /mnt/@
        btrfs subvolume snapshot /mnt/@fresh /mnt/@
        echo "POPULATING ROOT FOR MOUNTPOINTS..."
        mkdir /mnt/@/home
        mkdir /mnt/@/nix
        mkdir /mnt/@/persist
        mkdir /mnt/@/var
        mkdir /mnt/@/var/log
        mkdir /mnt/@/boot
        mkdir /mnt/@/boot/efi
        mkdir /mnt/@/mnt #optional but I like to have this directory :-)
      '';
    };
  };


  ### /etc/shadow ### hacky code snippet from thundertheidiot on Sep 30, 2024; thank you! :D : https://github.com/nix-community/impermanence/issues/120#issuecomment-2382674299
  system.activationScripts = {
    etc_shadow = ''
      [ -f "/etc/shadow" ] && cp /etc/shadow /persist/etc/shadow
      [ -f "/persist/etc/shadow" ] && cp /persist/etc/shadow /etc/shadow
    '';

    users.deps = ["etc_shadow"];
  };

  systemd = {
    services."etc_shadow_persistence" = {
      enable = true;
      description = "Persist /etc/shadow on shutdown.";
      wantedBy = ["multi-user.target"];
      path = [pkgs.util-linux];
      unitConfig.defaultDependencies = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        # Service is stopped before shutdown
        ExecStop = pkgs.writeShellScript "persist_etc_shadow" ''
          cp /etc/shadow /persist/etc/shadow
        '';
      };
    };
    tmpfiles.rules = [
      "d /persist/rootfs/etc/ 0755 root root -" # make sure /persist/etc exists
    ];
  };
  ### /etc/shadow (end) ###

}
