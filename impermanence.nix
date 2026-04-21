
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
      "/etc/group"
      "/etc/passwd"
      "/etc/shadow"
      "/etc/nixos"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/docker"
      "/var/lib/btrfs"
      "/var/lib/upower"
      "/var/lib/waydroid"
      "/var/lib/ollama"
      "/var/lib/private"
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
