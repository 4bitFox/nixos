
{ config, pkgs, lib, impermanence, ... }:


let
  wipelogo = ''
    \\t
    \\t
    \\t
    \\t        \#+ @      \# \#              M#@    
    \\t  .    .X  X.%##@;# \#   +@#######X. @H%   
    \\t    ,==.   ,######M+  -#####%M####M-    \# 
    \\t   :H##M%:=##+ .M##M,;#####/+#######% ,M# 
    \\t  .M########=  =@#@.=#####M=M#######=  X# 
    \\t  :@@MMM##M.  -##M.,#######M#######. =  M 
    \\t              @##..###:.    .H####. @@ X, 
    \\t    \############: \###,/####;  /##= @#. M  
    \\t            ,M## ;##,@#M;/M#M  @# X#% X#  
    \\t .%=   \######M## \##.M#:   ./#M ,M \#M ,#$  
    \\t \##/         \$## \#+;#: \#### ;#/ M M- @# : 
    \\t \#+ \#M@MM###M-;M \#:\$#-##\$H# .#X @ + \$#. \# 
    \\t       \######/.: \#%=# M#:MM./#.-#  @#: H# 
    \\t +,.=   @###: /@ %#,@  \##@X \#,-#@.##% .@# 
    \\t \#####+;/##/ @##  @#,+       /#M    . X,  
    \\t    ;###M#@ M###H .#M-     ,##M  ;@@; \### 
    \\t    .M#M##H ;####X ,@#######M/ -M###$  -H 
    \\t     .M###%  X####H  .@@MMM;  ;@#M@       
    \\t       H#M    /@####/      ,++.  / ==-,   
    \\t                ,=/:, .+X@MMH##H  \#####$= 
    \\t
    \\t
    \\t
  '';
in

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
      "/var/lib/systemd/random-seed"
      "/var/lib/systemd/credential.secret"
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
      systemd = {
        initrdBin = [
          pkgs.coreutils
        ];
        services = {
          impermanence_wiperoot = {
            description = "Impermanence filesystem preparation";
            wantedBy = [
              "initrd.target"
            ];
            before = [
              "sysroot.mount"
            ];
            after = [
              "initrd-root-device.target"
              "local-fs-pre.target" # Allow hibernation to resume before trying to alter any data
            ];
            requires = ["initrd-root-device.target"];
            unitConfig.DefaultDependencies = false;
            serviceConfig.Type = "oneshot";
            script = ''
              # ASCII art
              #${pkgs.coreutils}/bin/echo -e "${wipelogo}" > /dev/console

              # Script
              echo "MOUNTING ROOTFS..."
              mkdir /mnt > /dev/console
              mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt > /dev/console

              echo "CHECKING IF ROOT IS MARKED FOR DELETION..." > /dev/console
              if [ -f /mnt/__WIPE_ROOT_ON_BOOT ]; then
                ${pkgs.coreutils}/bin/echo "ROOT WAS MARKED FOR DELETION!" > /dev/console
                ${pkgs.coreutils}/bin/echo "DELETING ROOT..." > /dev/console
                set +e # DO NOT STOP ON FAIL
                btrfs subvolume delete /mnt/@/srv > /dev/console
                btrfs subvolume delete /mnt/@/var/lib/portables > /dev/console
                btrfs subvolume delete /mnt/@/var/lib/machines > /dev/console
                btrfs subvolume delete /mnt/@/var/tmp > /dev/console
                btrfs subvolume delete /mnt/@/@fresh 2>/dev/null # for when deleting fails and '@fresh' gets recreated in '@'...
                btrfs subvolume delete /mnt/@ > /dev/console
                ${pkgs.coreutils}/bin/echo "RECREATING ROOT..." > /dev/console
                btrfs subvolume snapshot /mnt/@fresh /mnt/@ > /dev/console
                ${pkgs.coreutils}/bin/echo "POPULATING ROOT FOR MOUNTPOINTS..." > /dev/console
                mkdir /mnt/@/home > /dev/console
                mkdir /mnt/@/nix > /dev/console
                mkdir /mnt/@/persist > /dev/console
                mkdir /mnt/@/var > /dev/console
                mkdir /mnt/@/var/log > /dev/console
                mkdir /mnt/@/boot > /dev/console
                mkdir /mnt/@/boot/efi > /dev/console
                mkdir /mnt/@/mnt > /dev/console #optional but I like to have this directory :-)
                ${pkgs.coreutils}/bin/echo "REMOVIMG 'WIPE ROOT ON BOOT' MARKER" > /dev/console
                rm /mnt/__WIPE_ROOT_ON_BOOT > /dev/console
                ${pkgs.coreutils}/bin/echo "SYSTEM IS FRESH! :-D" > /dev/console
              else
                ${pkgs.coreutils}/bin/echo "ROOT WAS NOT MARKED FOR DELETION AND WILL THEREFORE NOT BE WIPED!" > /dev/console
              fi

              ${pkgs.coreutils}/bin/echo "UNMOUNTING ROOTFS..." > /dev/console
              umount /mnt > /dev/console
              sleep 10 # DEBUGGING
            '';
          };
        };
      };
    };
  };

#  boot = {
#    initrd = {
#      postDeviceCommands = lib.mkAfter ''
#        echo "MOUNTING ROOTFS..."
#        mkdir /mnt
#        mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt
#        
#        echo "CHECKING IF ROOT IS MARKED FOR DELETION..."
#        if [ -f /mnt/__WIPE_ROOT_ON_BOOT ]; then
#          echo "ROOT WAS MARKED FOR DELETION!"
#          echo "                                              "
#          echo "                                              "
#          echo "                                              "
#          printf "\033[93m"
#          echo "                          -\$-                 "
#          echo "                         .H##H,               "
#          echo "                        +######+              "
#          echo "                     .+#########H.            "
#          echo "                   -\$############@.           "
#          echo "                 =H###############@  -X:      "
#          echo "               .\$##################:  @#@-    "
#          echo "          ,;  .M###################;  H###;   "
#          echo "        ;@#:  @###################@  ,#####:  "
#          echo "      -M###.  M#################@.  ;######H  "
#          echo "      M####-  +###############$   =@#######X  "
#          echo "      H####$   -M###########+   :#########M,  "
#          echo "       /####X-   =########%   :M########@/.   "
#          echo "         ,;%H@X;   .\$###X   :##MM@%+;:-       "
#          echo "                      ..                      "
#          printf "\033[31m"
#          echo "       -/;:-,.              ,,-==+M########H  "
#          echo "      -##################@HX%%+%%$%%%+:,,     "
#          echo "         .-/H%%%+%%\$H@###############M@+=:/+: "
#          echo "     /XHX%:#####MH%=    ,---:;;;;/&&XHM,:###$ "
#          echo "     \$@#MX %+;-                               "
#          printf "\033[0m"
#          echo "                                              "
#          echo "                                              "
#          echo "                                              "
#          echo "DELETING ROOT..."
#          btrfs subvolume delete /mnt/@/srv
#          btrfs subvolume delete /mnt/@/var/lib/portables
#          btrfs subvolume delete /mnt/@/var/lib/machines
#          btrfs subvolume delete /mnt/@/var/tmp
#          btrfs subvolume delete /mnt/@/@fresh 2>/dev/null # for when deleting fails and this gets created here...
#          btrfs subvolume delete /mnt/@
#          echo "RECREATING ROOT..."
#          btrfs subvolume snapshot /mnt/@fresh /mnt/@
#          echo "POPULATING ROOT FOR MOUNTPOINTS..."
#          mkdir /mnt/@/home
#          mkdir /mnt/@/nix
#          mkdir /mnt/@/persist
#          mkdir /mnt/@/var
#          mkdir /mnt/@/var/log
#          mkdir /mnt/@/boot
#          mkdir /mnt/@/boot/efi
#          mkdir /mnt/@/mnt #optional but I like to have this directory :-)
#          echo "REMOVIMG 'WIPE ROOT ON BOOT' MARKER"
#          rm /mnt/__WIPE_ROOT_ON_BOOT
#          echo "SYSTEM IS FRESH! :-D"
#        else
#          echo "ROOT WAS NOT MARKED FOR DELETION AND WILL THEREFORE NOT BE WIPED!"
#          echo "                                              "
#          echo "                                              "
#          echo "                                              "
#          echo "            \#+ @      \# \#              M#@    "
#          echo "      .    .X  X.%##@;# \#   +@#######X. @H%   "
#          echo "        ,==.   ,######M+  -#####%M####M-    \# "
#          echo "       :H##M%:=##+ .M##M,;#####/+#######% ,M# "
#          echo "      .M########=  =@#@.=#####M=M#######=  X# "
#          echo "      :@@MMM##M.  -##M.,#######M#######. =  M "
#          echo "                  @##..###:.    .H####. @@ X, "
#          echo "        \############: \###,/####;  /##= @#. M  "
#          echo "                ,M## ;##,@#M;/M#M  @# X#% X#  "
#          echo "     .%=   \######M## \##.M#:   ./#M ,M \#M ,#$  "
#          echo "     \##/         \$## \#+;#: \#### ;#/ M M- @# : "
#          echo "     \#+ \#M@MM###M-;M \#:\$#-##\$H# .#X @ + \$#. \# "
#          echo "           \######/.: \#%=# M#:MM./#.-#  @#: H# "
#          echo "     +,.=   @###: /@ %#,@  \##@X \#,-#@.##% .@# "
#          echo "     \#####+;/##/ @##  @#,+       /#M    . X,  "
#          echo "        ;###M#@ M###H .#M-     ,##M  ;@@; \### "
#          echo "        .M#M##H ;####X ,@#######M/ -M###$  -H "
#          echo "         .M###%  X####H  .@@MMM;  ;@#M@       "
#          echo "           H#M    /@####/      ,++.  / ==-,   "
#          echo "                    ,=/:, .+X@MMH##H  \#####$= "
#          echo "                                              "
#          echo "                                              "
#          echo "                                              "
#        fi
#
#        echo "UNMOUNTING ROOTFS..."
#        umount /mnt
#        echo ""
#      '';
#    };
#  };


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
