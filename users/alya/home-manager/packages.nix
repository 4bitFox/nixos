{ config, pkgs, lib, ... }:


{
  home = {
    packages = with pkgs; [
      xournalpp
      onlyoffice-desktopeditors
      obs-studio
      darktable
      texstudio
      ungoogled-chromium
      krita
      lutris
      fido2-manage
      freerdp
      protonmail-bridge
      thunderbird
      authenticator
      pdfarranger
      space-cadet-pinball
      openarena
      quodlibet-full
      blender
      mediawriter
      gnome-mines
      gnome-mahjongg
      vitetris
      quadrapassel
      luanti
      parabolic
      soundconverter
      prismlauncher
      osu-lazer
      zoom
      snapshot
      gnome-logs
      gnome-calculator
      geany
#      winboat
      easyeffects
#      alpaca
#      vesktop
      woeusb-ng
#      freecad
#      geogebra6
#      kdePackages.kdenlive
#      openscad
#      tor-browser
      gimp
      hyprpicker
      wl-clip-persist
      (python3.withPackages (python-pkgs: with python-pkgs; [
        rich
        numpy
        sympy
        matplotlib
        pandas
        scipy
        tabulate
        svgelements
      ]))
    ];
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Alya";
        email = "4bitFox@tschudibacon.com";
      };
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}
