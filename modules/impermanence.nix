
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
      "/var/lib/private/ollama"
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
        echo "MOUNTING ROOTFS..."
        mkdir /mnt
        mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt
        
        echo "CHECKING IF ROOT IS MARKED FOR DELETION..."
        if [ -f /mnt/__WIPE_ROOT_ON_BOOT ]; then
          echo "ROOT WAS MARKED FOR DELETION!"
          echo "                                              "
          echo "                                              "
          echo "                                              "
          printf "\033[93m"
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
          printf "\033[31m"
          echo "       -/;:-,.              ,,-==+M########H  "
          echo "      -##################@HX%%+%%$%%%+:,,     "
          echo "         .-/H%%%+%%\$H@###############M@+=:/+: "
          echo "     /XHX%:#####MH%=    ,---:;;;;/&&XHM,:###$ "
          echo "     \$@#MX %+;-                               "
          printf "\033[0m"
          echo "                                              "
          echo "                                              "
          echo "                                              "
          echo "DELETING ROOT..."
          btrfs subvolume delete /mnt/@/srv
          btrfs subvolume delete /mnt/@/var/lib/portables
          btrfs subvolume delete /mnt/@/var/lib/machines
          btrfs subvolume delete /mnt/@/var/tmp
          btrfs subvolume delete /mnt/@/@fresh 2>/dev/null # for when deleting fails and this gets created here...
          btrfs subvolume delete /mnt/@
          echo "RECREATING ROOT..."
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
          echo "REMOVIMG 'WIPE ROOT ON BOOT' MARKER"
          rm /mnt/__WIPE_ROOT_ON_BOOT
          echo "SYSTEM IS FRESH! :-D"
        else
          echo "ROOT WAS NOT MARKED FOR DELETION AND WILL THEREFORE NOT BE WIPED!"
          echo "                                              "
          echo "                                              "
          echo "                                              "
          echo "            \#+ @      \# \#              M#@    "
          echo "      .    .X  X.%##@;# \#   +@#######X. @H%   "
          echo "        ,==.   ,######M+  -#####%M####M-    \# "
          echo "       :H##M%:=##+ .M##M,;#####/+#######% ,M# "
          echo "      .M########=  =@#@.=#####M=M#######=  X# "
          echo "      :@@MMM##M.  -##M.,#######M#######. =  M "
          echo "                  @##..###:.    .H####. @@ X, "
          echo "        \############: \###,/####;  /##= @#. M  "
          echo "                ,M## ;##,@#M;/M#M  @# X#% X#  "
          echo "     .%=   \######M## \##.M#:   ./#M ,M \#M ,#$  "
          echo "     \##/         \$## \#+;#: \#### ;#/ M M- @# : "
          echo "     \#+ \#M@MM###M-;M \#:\$#-##\$H# .#X @ + \$#. \# "
          echo "           \######/.: \#%=# M#:MM./#.-#  @#: H# "
          echo "     +,.=   @###: /@ %#,@  \##@X \#,-#@.##% .@# "
          echo "     \#####+;/##/ @##  @#,+       /#M    . X,  "
          echo "        ;###M#@ M###H .#M-     ,##M  ;@@; \### "
          echo "        .M#M##H ;####X ,@#######M/ -M###$  -H "
          echo "         .M###%  X####H  .@@MMM;  ;@#M@       "
          echo "           H#M    /@####/      ,++.  / ==-,   "
          echo "                    ,=/:, .+X@MMH##H  \#####$= "
          echo "                                              "
          echo "                                              "
          echo "                                              "
        fi

        echo "UNMOUNTING ROOTFS..."
        umount /mnt
        echo ""
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
    services = {
      etc_shadow_persistence = {
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
      wipe_root_on_next_boot_marker = {
        enable = true;
        description = "Mark root for deletion on poweroff or reboot";
        wantedBy = ["multi-user.target"];
        path = [pkgs.util-linux];
        unitConfig.defaultDependencies = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # Service is stopped before shutdown
          ExecStop = pkgs.writeShellScript "wipe_root_on_next_boot" ''
            umount -Rq /mnt
            mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt
            touch /mnt/__WIPE_ROOT_ON_BOOT
            umount /mnt
          '';
        };
      };
    };
    tmpfiles.rules = [
      "d /persist/rootfs/etc/ 0755 root root -" # make sure /persist/etc exists
    ];
  };
  ### /etc/shadow (end) ###

}
