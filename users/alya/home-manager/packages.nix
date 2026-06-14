{ config, pkgs, lib, ... }:


let
  ### In case I need to disable pycheck. Untested for now but might try/need later...
  # Use like this: (dontCheckPython pkgs.pythonPackage)
  dontCheckPython = drv:
    drv.overridePythonAttrs (old: {
      doCheck = false;
    }
  );  
in

{
  home = {
    packages = with pkgs; [
      xournalpp
      onlyoffice-desktopeditors
      texstudio
      krita
      lutris
      fido2-manage
      freerdp
      protonmail-bridge
      thunderbird
      quodlibet-full
      blender
      snapshot
      gnome-logs
      gnome-calculator
      easyeffects
      alpaca
      woeusb-ng
      ungoogled-chromium
      kdePackages.kdenlive
      tor-browser
      gimp
      hyprpicker
      wl-clip-persist
      super-slicer
      mtkclient
      ventoy-full-gtk
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
  
  file = {
    ### Double Commander Qt6 ###
      ".local/opt/doublecmd" = {
        source = ./homefiles/.local/opt/doublecmd/doublecmd_qt6_x86_64;
        recursive = true;
      };
      ".local/share/applications/doublecmd.desktop" = {
        source = ./homefiles/.local/opt/doublecmd/doublecmd.desktop;
      };
    };
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
