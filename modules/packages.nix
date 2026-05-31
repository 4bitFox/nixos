
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
      screen
      unrar
      tree
      android-tools # replaces "programs.adb.enable = true;"
      nix-output-monitor
      simple-scan
    ];
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add any missing dynamic libraries for unpackaged programs
        # here, NOT in environment.systemPackages
        wayland
        libx11
        gtk2
        gtk3
        gtk4
        qt5.qtbase
        qt6.qtbase
        glib
        dbus
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
    ];
  };

  documentation.nixos.enable = false;
}
