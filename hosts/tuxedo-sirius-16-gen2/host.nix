
{ config, pkgs, lib, ... }:


{
  imports = [
    ./_partitions.nix
    ./specialisations/_gpu-passtrough.nix
  ];

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };


  hardware = {
    tuxedo-drivers.enable = true;
  };

  systemd = {
    sleep.settings.Sleep = {
      SuspendState = "freeze";
    };
  };

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm; # Use AMD GPU for ollama
      loadModels = [
        # general
        "llama3.1:8b"
        # reasoning
        "deepseek-r1:8b"
      ];
      syncModels = true;
      rocmOverrideGfx = "11.0.2";
    };
  };

  # boot.initrd.kernelModules = [ "amdgpu" ];

  environment = {
    systemPackages = with pkgs; [
      radeontop
      rocmPackages.rocminfo
    ];
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };

  
  specialisation = {
    gpu-passtrough = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "gpu-passthrough" ];

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
      };
    };
  };
}
