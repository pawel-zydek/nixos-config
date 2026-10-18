{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-zfs";
  networking.hostId = "379d459b";          # własne 8 znaków hex
  my.disk = "/dev/disk/by-id/scsi-360022480ee42d138a5b20c748069ed09";

  # tylko dla Hyper-V
  virtualisation.hypervGuest.enable = true;
  boot.kernelModules = [ "hv_sock" ];
}
