{ ... }:
{
  # Obsługa dysków NTFS (pendrive'y, dyski z Windows)
  boot.supportedFilesystems = [ "ntfs" ];

  # Każe udisks preferować ntfs-3g zamiast ntfs3
  environment.etc."udisks2/mount_options.conf".text = ''
    [defaults]
    ntfs_drivers=ntfs,ntfs3
  '';
}
