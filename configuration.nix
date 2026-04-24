
{ config, pkgs, lib, ... }:


### NixOS was installed using the following guide: ###
# https://mieszkocichon.eu/2025/09/30/installing-nixos-with-full-disk-encryption-lvm-and-btrfs-subvolumes/
# https://web.archive.org/web/20260412094844/https://mieszkocichon.eu/2025/09/30/installing-nixos-with-full-disk-encryption-lvm-and-btrfs-subvolumes/

{
  imports = [
    ./hardware-configuration.nix
    ./fonts.nix
    ./keyboard.nix
    ./datetime.nix
    ./services.nix
    ./virtualisation.nix
    ./networking.nix
    ./users/alya/user.nix
    ./nix.nix
    ./locales.nix
    ./boot.nix
    ./packages.nix
    ./hardware.nix
    ./graphical/niri.nix
    ./audio.nix
    ./printing.nix
    ./home-manager.nix
    ./declarative-flatpak.nix
    ./impermanence.nix
    ./partitions.nix
  ];





  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
