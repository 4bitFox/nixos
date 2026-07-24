
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

  system.activationScripts.maskXdgAutostartGenerator = {
    text = ''
      mkdir -p /etc/systemd/user-generators
      ln -sfn /dev/null /etc/systemd/user-generators/systemd-xdg-autostart-generator
    '';
  };
}
