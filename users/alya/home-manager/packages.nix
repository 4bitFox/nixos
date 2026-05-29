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
      # ungoogled-chromium
      kdePackages.kdenlive
      # openscad
      # tor-browser
      gimp
      hyprpicker
      wl-clip-persist
      doublecmd
      super-slicer
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
