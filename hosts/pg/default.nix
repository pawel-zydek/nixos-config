{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ../../modules/laptop.nix
    ../../modules/kvm.nix
    ../../modules/gns3.nix
    ../../modules/wireshark.nix
    ../../modules/optical.nix
  ];

  networking.hostName = "nixos-pg";
  networking.hostId = "2f9bb339";          # własne 8 znaków hex
  my.disk = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNF0WB12095W";

  # Dodatkowe datasety tylko na laptopie (dopisują się do modules/disko-zfs.nix)
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

  # Limit pamięci podręcznej ZFS (ARC) - 8 GiB, reszta RAM dla VM
  boot.kernelParams = [ "zfs.zfs_arc_max=8589934592" ];
}
