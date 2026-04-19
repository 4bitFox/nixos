
{ config, pkgs, lib, ... }:


{
#  boot = {
#    initrd.kernelModules = [
#       "vfio_pci"
#       "vfio"
#       "vfio_iommu_type1"
#      "kvmfr" # for looking-glass
#    ];
#    kernelModules = [  ];
#    kernelParams = [
#      "amd_iommu=on"
#      "iommu=pt"
#      "vfio-pci.ids=1002:7480,1002:ab30"
#      "kvmfr.static_size_mb=64" # for looking-glass
#    ];
#    extraModulePackages = [
#      config.boot.kernelPackages.kvmfr
#    ];
#  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        vhostUserPackages = with pkgs; [
          virtiofsd
        ];
#        verbatimConfig = ''
#        namespaces = []
#        cgroup_device_acl = [
#          "/dev/null", "/dev/full", "/dev/zero",
#          "/dev/random", "/dev/urandom",
#          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
#          "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
#          "/dev/kvmfr0"
#        ]'';
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

#  environment = {
#    systemPackages = with pkgs; [
#      looking-glass-client
#    ];
#  };
}
