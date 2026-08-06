
{ config, pkgs, lib, ... }:

### https://wiki.nixos.org/wiki/ZFS ###
# Selecting the latest ZFS-compatible Kernel
# Warning: This will often result in the Kernel version going backwards as Kernel versions become end-of-life and are removed from Nixpkgs.

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in

{
  boot = {
    kernelPackages = latestKernelPackage; # Note this might jump back and forth as kernels are added or removed.
  };
}
