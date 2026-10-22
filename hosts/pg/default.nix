{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ../../modules/kvm.nix
    ../../modules/wireshark.nix
    ../../modules/optical.nix
  ];

  networking.hostName = "nixos-pg";
  networking.hostId = "2f9bb339";          # własne 8 znaków hex
  my.disk = "/dev/disk/by-id/UZUPEŁNIĆ";
}
