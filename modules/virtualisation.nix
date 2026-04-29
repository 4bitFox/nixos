
{ config, pkgs, lib, ... }:


{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [
          virtiofsd
        ];
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
    docker = {
      enable = false; # Using rootless docker instead
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    waydroid.enable = true;
  };

  environment.systemPackages = with pkgs; [
    guestfs-tools
  ];

  programs = {
    virt-manager.enable = true;
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
