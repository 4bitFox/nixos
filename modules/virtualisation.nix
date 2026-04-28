
{ config, pkgs, lib, ... }:


{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
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
    virtiofsd
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
