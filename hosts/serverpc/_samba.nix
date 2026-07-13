
{ config, pkgs, lib, ... }:

# https://wiki.nixos.org/wiki/Samba

{
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "caroline";
          "netbios name" = "caroline";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "share" = {
          "path" = "/data/samba/share";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "sambauser";
          "force group" = "sambagroup";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };


  users = {
    groups = {
      sambagroup = {
        gid = 2000;
      };
    };
    users = {
      sambauser = {
        isSystemUser = true;
        home = "/var/empty";
        createHome = false;
        shell = "${pkgs.shadow}/bin/nologin";
        uid = 2000;
        group = "sambagroup";
      };
    };
  };
}
