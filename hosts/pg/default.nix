{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./disko.nix                # układ dysku (disko)
    ../../modules/nixos
  ];

  # --- Tożsamość hosta ---
  networking.hostName = "nixos-pg";
  networking.hostId = "2f9bb339";          # własne 8 znaków hex (wymagane przez ZFS)

  # --- Co jest włączone na tym hoście ---
  my.zfs.enable = true;
  my.ntfs.enable = true;
  my.desktop.plasma.enable = true;
  my.audio.enable = true;

  my.hardware.firmware.enable = true;
  my.hardware.intelGraphics.enable = true;
  my.hardware.fingerprint.enable = true;
  my.hardware.bluetooth.enable = true;

  my.services.printing.enable = true;

  my.virtualisation.libvirt.enable = true;
  my.virtualisation.gns3.enable = true;

  my.programs.wireshark.enable = true;
  my.programs.optical.enable = true;

  # Limit pamięci podręcznej ZFS (ARC) - 8 GiB, reszta RAM dla VM
  boot.kernelParams = [ "zfs.zfs_arc_max=8589934592" ];

  # Wersja systemu, na której pierwotnie zainstalowano NixOS - nie zmieniać
  system.stateVersion = "26.05";
}
