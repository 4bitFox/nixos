
{ config, pkgs, lib, impermanence, ... }:


{
  imports = [
    impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist" = { 
    neededForBoot = true;
  };

  environment.persistence."/persist" = {
    enable = false; #####
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
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
      ### DANGER !!! ### I have to set up persist first before uncommenting! (note to self lol}
      #  echo "DELETING ROOT..."
      #  mkdir /mnt
      #  mount -t btrfs /dev/mapper/GLaDOS_lvm-GLaDOS_rootfs /mnt
      #  btrfs subvolume delete /mnt/@
      #  btrfs subvolume snapshot /mnt/@fresh /mnt/@
      #  echo "POPULATING ROOT FOR MOUNTPOINTS..."
      #  mkdir /mnt/@/home
      #  mkdir /mnt/@/nix
      #  mkdir /mnt/@/persist
      #  mkdir /mnt/@/var
      #  mkdir /mnt/@/var/log
      #  mkdir /mnt/@/boot
      #  mkdir /mnt/@/boot/efi
      #  mkdir /mnt/@/mnt #optional but I like to have it :-)
      '';
    };
  };
}
