
{ config, pkgs, lib, ... }:


{
  specialisation = {
    gpu-passthrough = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "fhnw" ];

        ### GPU-Passthrough ###
        boot = {
          kernelPatches = [
            {
              ### Tuxedo Sirius 16 Gen 2 allow GPU passtrough patch ###
              name = "disable-IOMMU-direct-mappings-check";
              patch = ./patches/kernel/my_probably_extremely_stupid_IOMMU_direct_mappings.patch;
            }
          ];

          initrd.kernelModules = lib.mkForce (
            lib.filter (m: m != "amdgpu") config.boot.initrd.kernelModules ++ [ # throw out amdgpu but otherwise inherit kernelModules
              "vfio_pci"
              "vfio"
              "vfio_iommu_type1"
              "kvmfr" # for looking-glass
            ]
          );
          kernelParams = [
            "amd_iommu=on"
            "iommu=pt"
            "vfio-pci.ids=1002:7480,1002:ab30"
            "kvmfr.static_size_mb=64" # for looking-glass
          ];
          extraModulePackages = [
            config.boot.kernelPackages.kvmfr
          ];
        };

        services.udev.packages = lib.singleton (pkgs.writeTextFile
          {
            name = "kvmfr";
            text = ''
              SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/70-kvmfr.rules";
          }
        );

        virtualisation.libvirtd.qemu = {
          verbatimConfig = ''
            namespaces = []
            cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
              "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
              "/dev/kvmfr0"
            ]
          '';
        };

        environment = {
          systemPackages = with pkgs; [
            looking-glass-client
          ];
        };
      ### GPU-Passthrough (end) ###

      ### EDUROAM ###
      networking = {
        nameservers = lib.mkForce [ ]; # let eduroam use it's own DNS.
        networkmanager = {
          dns = lib.mkForce "default"; # let NM manage resolv.conf normally to not fuck with eduroam DNS
          ensureProfiles.profiles = {
            eduroam = {
              connection = {
                id = "eduroam";
                type = "wifi";
                autoconnect = false;
              };
              wifi = {
                ssid = "eduroam";
                mode = "infrastructure";
              };
              wifi-security = {
                key-mgmt = "wpa-eap";
              };
              "802-1x" = {
                eap = "peap";
                phase2-auth = "mschapv2";
                ca-cert = "/etc/ssl/certs/ca-bundle.crt";
              };
              ipv4.method = "auto";
              ipv6.method = "auto";
            };
          };
        };
      };
      ### EDUROAM (end) ###
      };
    };
  };
}
