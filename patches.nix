
{ config, pkgs, lib, ... }:


{
  boot.kernelPatches = [
#    {
#      name = "tux-logo";
#      patch = null;
#      structuredExtraConfig = with lib.kernel; {
#        # options without 'CONFIG_' prefix!
#        LOGO = lib.mkForce yes;
#        LOGO_LINUX_CLUT224 = yes;
#      };
#    }
  ];
}
