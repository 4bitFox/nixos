
{ config, pkgs, lib, ... }:


{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        glados-rebuild-switch = "git -C /etc/nixos add . ; git -C /etc/nixos commit -m 'nixos-rebuild switch' ; sudo sh -c 'nixos-rebuild switch --log-format internal-json |& nom --json'";
        glados-rebuild-boot = "git -C /etc/nixos add . ; git -C /etc/nixos commit -m 'nixos-rebuild boot' ; sudo sh -c 'nixos-rebuild boot --log-format internal-json |& nom --json'";
        glados-rebuild-test = "git -C /etc/nixos add . ; git -C /etc/nixos commit -m 'nixos-rebuild test' ; sudo sh -c 'nixos-rebuild test --log-format internal-json |& nom --json'";
        glados-clean = "sudo nix-collect-garbage --delete-older-than 30d";
        glados-status-flatpak = "systemctl --user status manage-flatpaks-activation.service";
        glados-status-ollama-models = "systemctl status ollama-model-loader.service";
      };
    };
  };
}
