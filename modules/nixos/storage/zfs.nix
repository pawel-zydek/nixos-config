{ config, lib, ... }:
let
  cfg = config.my.zfs;
in
{
  options.my.zfs.enable = lib.mkEnableOption "ZFS (system na puli rpool, scrub, trim, snapshoty sanoid)";

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.devNodes = "/dev/disk/by-id";
    boot.zfs.forceImportRoot = false;

    services.zfs.autoScrub.enable = true;
    services.zfs.trim.enable = true;

    # Snapshoty /home
    services.sanoid = {
      enable = true;
      templates.default = {
        hourly = 24;
        daily = 7;
        monthly = 3;
        autosnap = true;
        autoprune = true;
      };
      datasets."rpool/home".useTemplate = [ "default" ];
    };

    # Ukrycie partycji ZFS w Dolphinie
    services.udev.extraRules = ''
      ENV{ID_FS_TYPE}=="zfs_member", ENV{UDISKS_IGNORE}="1"
    '';
  };
}
