
{ config, pkgs, lib, ... }:


{
  imports = [
    ./packages/bash.nix
    ./packages/firefox.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      nano
      vim
      wget
      htop
      docker-compose
      gparted
      dnsmasq
      texliveFull
      bc
      pciutils
      usbutils
      cifs-utils
      android-tools
      input-remapper
      lynx
      mc
      radeontop
      screen
      unrar
      timeshift
      tree
      android-tools # replaces "programs.adb.enable = true;"
      nix-output-monitor
    ];
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };

  programs = {
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
    ];
  };

  documentation.nixos.enable = false;
}
