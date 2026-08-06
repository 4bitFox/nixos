
{ config, pkgs, lib, ... }:


{
  users.users.alya = {
    isNormalUser = true;
    description = "Alicia";
    extraGroups = [
      "networkmanager"
      "wheel"
      "qemu"
      "libvirtd"
      "kvm"
      "flatpak"
      "docker"
      "adbusers"
    ];
    uid = 1000;
    packages = with pkgs; [  ];
  };

  ### home-manager ###
  home-manager.users.alya = import ./home-manager/home.nix;
}
