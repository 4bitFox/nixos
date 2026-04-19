
{ config, pkgs, lib, ... }:


{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplipWithPlugin
        gutenprint
        gutenprintBin
        postscript-lexmark
        samsung-unified-linux-driver
        splix
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
        cnijfilter2
        epson-escpr2
        epson-escpr
      ];
    };
#    avahi = {
#      enable = true;
#      nssmdns4 = true;
#      openFirewall = true;
#    };
    system-config-printer.enable = true;
  };
}
