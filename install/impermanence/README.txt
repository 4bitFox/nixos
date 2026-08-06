fix_dbus-machine-id
- Is required after enabling impermanence for the first time so the symlink doesn't fail because there is no machine-id in persist. Fixes stuck on dbus on boot.

fix_systemd-credentials.sh
- make systemd credentials work again. Required for libvirtd.
