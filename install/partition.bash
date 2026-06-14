#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root!"
  exit 1
fi

mountpoint -q /mnt && { echo "/mnt is mounted! aborting"; exit 1; }

echo "Manually create unformatted partitions for 'ESP/EFI' (1024 MiB) (optional), 'boot' (2048 MiB) and 'luks (optional) + lvm rootfs and swap' (rest of space) using fdisk, gparted or other tool."
echo "In the next step you will be asked to enter the path to the partitions. (example: /dev/sdxN)"
read -p "Press Enter to continue..." 

echo ""
read -r -p "Enter path for partition 'ESP' for a UEFI install; leave blank for a BIOS install: " PARTITION_ESP

if [ -z "$PARTITION_ESP" ]; then
  echo "BIOS install selected"
  UEFI_INSTALL=0
else
  echo "PARTITION FOR ESP: $PARTITION_ESP"
  UEFI_INSTALL=1
fi

echo ""
read -r -p "Enter path for partition 'boot': " PARTITION_BOOT
echo "PARTITION FOR BOOT: $PARTITION_BOOT"

echo ""
read -r -p "Enter path for partition 'rootfs': " PARTITION_ROOTFS
echo "PARTITION FOR ROOTFS: $PARTITION_ROOTFS"

echo ""
read -r -p "Enter size for partition 'swap' in MiB (GB*1024MiB): " PARTITION_SIZE_SWAP
echo "PARTITION SIZE FOR SWAP: $PARTITION_SIZE_SWAP MiB"
echo "ROOTFS WILL USE REST OF AVAILABLE SPACE"

echo ""
LABEL_ROOTFS="GLaDOS"
# read -r -p "ROOTFS LABEL (e.g. rootfs): " LABEL_ROOTFS
echo "LABEL FOR ROOTFS: $LABEL_ROOTFS"

if [[ "$UEFI_INSTALL" -eq 1 ]]; then
  if [[ ! -b "$PARTITION_ESP" ]]; then
    echo "Error: $PARTITION_ESP is not a valid block device"
    exit 1
  fi
fi

for p in "$PARTITION_BOOT" "$PARTITION_ROOTFS"; do
  if [[ ! -b "$p" ]]; then
    echo "Error: $p is not a valid block device"
    exit 1
  fi
done

read -r -p "Use LUKS encryption? (y/N): " USE_LUKS

if [[ "$USE_LUKS" == "y" || "$USE_LUKS" == "yes" ]]; then
  USE_LUKS=1
else
  USE_LUKS=0
fi

echo ""
echo "MAKE SURE THE SELECTED PARTITIONS ARE CORRECT. THEIR DATA WILL BE DESTROYED!!!"
read -r -p "Type 'YES' to continue: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || { echo "Aborted."; exit 1; }



echo ""
if [[ "$UEFI_INSTALL" -eq 1 ]]; then
  echo "Setting ESP + boot + hidden flags on $PARTITION_ESP"
  PARTITION_ESP_PARTED_DISK=$(lsblk -no pkname "$PARTITION_ESP" | sed 's|^|/dev/|')
  PARTITION_ESP_PARTED_PARTNUM="$(lsblk -no partn "$PARTITION_ESP")"
  parted "$PARTITION_ESP_PARTED_DISK" set "$PARTITION_ESP_PARTED_PARTNUM" esp on
  parted "$PARTITION_ESP_PARTED_DISK" set "$PARTITION_ESP_PARTED_PARTNUM" boot on
  parted "$PARTITION_ESP_PARTED_DISK" set "$PARTITION_ESP_PARTED_PARTNUM" hidden on
  echo "Formatting $PARTITION_ESP"
  mkfs.fat -F32 -n "$LABEL_ROOTFS"_ESP "$PARTITION_ESP"
fi

echo ""
echo "Setting hidden flag on $PARTITION_BOOT"
PARTITION_BOOT_PARTED_DISK=$(lsblk -no pkname "$PARTITION_BOOT" | sed 's|^|/dev/|')
PARTITION_BOOT_PARTED_PARTNUM="$(lsblk -no partn "$PARTITION_BOOT")"
parted "$PARTITION_BOOT_PARTED_DISK" set "$PARTITION_BOOT_PARTED_PARTNUM" hidden on
echo "Formatting $PARTITION_BOOT"
mkfs.ext4 -L "$LABEL_ROOTFS"_boot "$PARTITION_BOOT"

echo "Formatting $PARTITION_ROOTFS"
if [[ "$USE_LUKS" -eq 1 ]]; then
echo "LUKS encryption:"
  cryptsetup luksFormat "$PARTITION_ROOTFS" --label "$LABEL_ROOTFS"_luks
  cryptsetup open "$PARTITION_ROOTFS" "$LABEL_ROOTFS"_luks
  PV_DEVICE="/dev/mapper/${LABEL_ROOTFS}_luks"
else
  PV_DEVICE="$PARTITION_ROOTFS"
fi

echo ""
echo "Creating LVM"
pvcreate "$PV_DEVICE"
vgcreate "$LABEL_ROOTFS"_lvm "$PV_DEVICE"

echo ""
echo "Create SWAP"
lvcreate -L "$PARTITION_SIZE_SWAP"M -n "$LABEL_ROOTFS"_swap "$LABEL_ROOTFS"_lvm
mkswap -L "$LABEL_ROOTFS"_swap /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_swap

echo ""
echo "Create rootfs"
lvcreate -l '100%FREE' -n "$LABEL_ROOTFS"_rootfs "$LABEL_ROOTFS"_lvm
mkfs.btrfs -L "$LABEL_ROOTFS" /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs


echo ""
echo "Create btrfs subvolumes in rootfs"
mount /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
btrfs subvolume create /mnt/@log
btrfs subvolume snapshot -r /mnt/@ /mnt/@fresh
umount /mnt

echo ""
echo "Mounting"
mount -o compress=zstd,subvol=@ /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt
mkdir /mnt/home
mkdir /mnt/nix
mkdir /mnt/persist
mkdir /mnt/var
mkdir /mnt/var/log
mount -o compress=zstd,subvol=@home /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt/home
mount -o compress=zstd,noatime,subvol=@nix /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt/nix
mount -o compress=zstd,subvol=@persist /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt/persist
mount -o compress=zstd,subvol=@log /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_rootfs /mnt/var/log
mkdir /mnt/boot
mount "$PARTITION_BOOT" /mnt/boot

if [[ "$UEFI_INSTALL" -eq 1 ]]; then
  mkdir /mnt/boot/efi
  mount "$PARTITION_ESP" /mnt/boot/efi
fi
swapon /dev/"$LABEL_ROOTFS"_lvm/"$LABEL_ROOTFS"_swap

echo "Generating NixOS config"
nixos-generate-config --root /mnt


echo ""
echo "DONE! You can now edit the config in '/mnt/etc/nixos/'"
echo ""
echo "REQUIRED CHANGES in configuration.nix!!!"
echo "REMOVE this from configuration.nix:"
echo "  boot.loader.systemd-boot.enable = true;"
echo "ADD this to configuration.nix:"
echo "  boot.loader.grub.enable = true;"
echo "  boot.loader.grub.device = \"nodev\";"
if [[ "$UEFI_INSTALL" -eq 1 ]]; then
  echo "  boot.loader.grub.efiSupport = true;"
  echo "  boot.loader.efi.efiSysMountPoint = \"/boot/efi\";"
fi
if [[ "$USE_LUKS" -eq 1 ]]; then
  echo "  boot.initrd.luks.devices = {"
  echo "    luksroot = {"
  PARTITION_ROOTFS_UUID=$(blkid -s UUID -o value "$PARTITION_ROOTFS")
  echo "      device = \"/dev/disk/by-uuid/$PARTITION_ROOTFS_UUID\";"
  echo "      preLVM = true;"
  echo "      allowDiscards = true;"
  echo "    };"
  echo "  };"
fi
echo ""
echo "Other useful options:"
echo " - Console keymap (in this case swissgerman):"
echo "  console.keyMap = \"sg\";"
echo " - Enable Flakes:"
echo "  nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];"
echo "After all the configuration has been made, run 'nixos-install' to install; fingers crossed."

echo ""
read -p "Press Enter to exit..."
exit
