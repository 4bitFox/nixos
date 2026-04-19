{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".local/opt/view-screencast/view-screencast.html" = {
        source = ./homefiles/.local/opt/view-screencast/view-screencast.html;
      };
      ".local/opt/view-screencast/view-screencast.sh" = {
        source = ./homefiles/.local/opt/view-screencast/view-screencast.sh;
        executable = true;
      };
      ".local/share/applications/view-screencast.desktop" = {
        source = ./homefiles/.local/opt/view-screencast/view-screencast.desktop;
        executable = true;
      };
    };
  };
}
