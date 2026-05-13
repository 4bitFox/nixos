
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
        glados-update = "sudo cp /etc/nixos/flake.lock /etc/nixos/flake.lock.bak || exit 1 ; git -C /etc/nixos add . ; git -C /etc/nixos commit -m 'nix flake update' ;  sudo nix flake update --flake /etc/nixos";
        glados-status-flatpak = "systemctl --user status manage-flatpaks-activation.service";
        glados-status-ollama-models = "systemctl status ollama-model-loader.service";
      };
    };
  };
}
