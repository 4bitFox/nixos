
{ config, pkgs, lib, ... }:


{
  programs = {
    niri = {
      enable = true;
      useNautilus = true;
    };
    waybar.enable = true;
    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # kdePackages.polkit-kde-agent-1
      hyprpolkitagent
      xwayland-satellite
    ];
  };

  services = {
    displayManager = {
      defaultSession = "niri";
      autoLogin = {
        enable = true;
        user = "alya";
      };
      gdm = {
        enable = true;
      };
    };
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    upower.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    config = {
      common.default = "gtk";
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    # config.common.default = "*";
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  # get rid of that pesky autostart generator, omg I hate it.
  # rebuildds a lot of pkgs tough :c
#  nixpkgs.overlays = [
#    (final: prev: {
#      systemd = prev.systemd.overrideAttrs (old: {
#        postInstall = (old.postInstall or "") + ''
#          rm -f $out/lib/systemd/user-generators/systemd-xdg-autostart-generator
#        '';
#      });
#    })
#  ];
}
