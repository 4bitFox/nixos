
{ config, pkgs, lib, ... }:


let
  ### COMPATIBILITY: missing dynamic libraries for unpackaged programs and extra packages for appimage-run ###
  compatPkgs = with pkgs; [
    wayland
    libx11
    gtk2
    gtk3
    gtk4
    qt5.qtbase
    qt6.qtbase
    glib
    dbus
    libGL
    atk
    pango
    gdk-pixbuf
    cairo
    libsForQt5.qtx11extras
  ];
  ### COMPATIBILITY (end) ###
in

{
  imports = [
    ./packages/_bash.nix
    ./packages/_firefox.nix
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
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: compatPkgs;
      };
    };
    nix-ld = {
      enable = true;
      libraries = compatPkgs;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
    ];
  };

  documentation.nixos.enable = false;
}
