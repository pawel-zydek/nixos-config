{ config, lib, ... }:
let
  cfg = config.my.ntfs;
in
{
  options.my.ntfs.enable = lib.mkEnableOption "obsługa dysków NTFS (pendrive'y, dyski z Windows)";

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];

    # Każe udisks preferować ntfs-3g zamiast ntfs3
    environment.etc."udisks2/mount_options.conf".text = ''
      [defaults]
      ntfs_drivers=ntfs,ntfs3
    '';
  };
}
