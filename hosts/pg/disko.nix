{ ... }:
{
  # Dodatkowe datasety tylko na laptopie
  # (dopisują się do wspólnego układu z modules/nixos/storage/disko-zfs.nix)
  disko.devices.zpool.rpool.datasets = {
    # obrazy maszyn wirtualnych (Windows 11) - osobny dataset
    vm = {
      type = "zfs_fs";
      mountpoint = "/var/lib/libvirt/images";
      options = {
        mountpoint = "legacy";
        recordsize = "64K";                # = rozmiar klastra qcow2
      };
    };

    # dyski maszyn laboratoryjnych (np. klaster incus-cluster) - snapshoty niezależne od Windows 11
    vm-lab = {
      type = "zfs_fs";
      mountpoint = "/var/lib/libvirt/vm-lab";
      options = {
        mountpoint = "legacy";
        recordsize = "64K";                # = rozmiar klastra qcow2
        atime = "off";
      };
    };

    # rezerwa: pula nigdy nie zapełni się w 100%
    reserved = {
      type = "zfs_fs";
      options = {
        mountpoint = "none";
        canmount = "off";
        refreservation = "50G";
      };
    };
  };
}
