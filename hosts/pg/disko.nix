{ ... }:
{
  # Układ dysku laptopa: ESP 1G + szyfrowana pula ZFS rpool.
  # Używany przy instalacji (disko) i do generowania fileSystems.
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNF0WB12095W";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            size = "100%";
            content = { type = "zfs"; pool = "rpool"; };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      options = { ashift = "12"; autotrim = "on"; };
      rootFsOptions = {
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
        relatime = "on";
        normalization = "formD";
        dnodesize = "auto";
        mountpoint = "none";
        canmount = "off";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
      };

      datasets = {
        root = { type = "zfs_fs"; mountpoint = "/";     options.mountpoint = "legacy"; };
        nix  = { type = "zfs_fs"; mountpoint = "/nix";  options.mountpoint = "legacy"; };
        var  = { type = "zfs_fs"; mountpoint = "/var";  options.mountpoint = "legacy"; };
        home = { type = "zfs_fs"; mountpoint = "/home"; options.mountpoint = "legacy"; };

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
    };
  };
}
