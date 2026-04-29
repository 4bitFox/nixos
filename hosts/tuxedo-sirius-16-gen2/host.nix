{ config, pkgs, lib, ... }:


{
  imports = [
    ./hardware-configuration.nix
  ];


  hardware = {
    tuxedo-drivers.enable = true;
  };

  systemd = {
    sleep.extraConfig = ''
      SuspendState=freeze
    '';
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

  boot.initrd.kernelModules = [ "amdgpu" ];

  environment = {
    systemPackages = with pkgs; [
      radeontop
      rocmPackages.rocminfo
    ];
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };

  nixpkgs.overlays = [
    ### Tuxedo Sirius 16 dual speaker patch ###
    (final: prev: {
      alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          # ./patches/alsa-ucm-conf/tuxedo-sirius16_dual-speaker.patch
          (builtins.fetchurl {
            url = "https://github.com/alsa-project/alsa-ucm-conf/pull/533.patch";
            sha256 = "465c5fe560725ccc7f3e319d543a99160b8af46a047e8a2816b6b4671dbfdab9";
          })
        ];
      });
    })
  ];


  
  specialisation = {
    gpu-passtrough = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "gpu-passthrough" ];
        environment.etc."specialisation".text = "gpu-passthrough";

        boot = {
          kernelPatches = [
            {
              ### Tuxedo Sirius 16 Gen 2 allow GPU passtrough patch ###
              name = "disable-IOMMU-direct-mappings-check";
              patch = ./patches/kernel/my_probably_extremely_stupid_IOMMU_direct_mappings.patch;
            }
          ];

          initrd.kernelModules = lib.filter (m: m != "amdgpu") config.boot.initrd.kernelModules ++ [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
            "kvmfr" # for looking-glass
          ];
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
