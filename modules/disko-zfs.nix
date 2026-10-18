{ lib, config, ... }:
{
  options.my.disk = lib.mkOption {
    type = lib.types.str;
    description = "Ścieżka do dysku, np. /dev/disk/by-id/...";
  };

  config.disko.devices = {
    disk.main = {
      type = "disk";
      device = config.my.disk;
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
      };
    };
  };
}