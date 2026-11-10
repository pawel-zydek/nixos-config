{ inputs, ... }:
{
  # Wszystkie moduły systemowe. Moduły z core/ działają zawsze,
  # pozostałe nic nie robią, dopóki host ich nie włączy (my.<nazwa>.enable = true).
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./core/nix.nix
    ./core/boot.nix
    ./core/locale.nix
    ./core/users.nix
    ./core/network.nix
    ./core/packages.nix
    ./core/home-manager.nix

    ./storage/zfs.nix
    ./storage/ntfs.nix

    ./desktop/plasma.nix
    ./desktop/audio.nix

    ./hardware/firmware.nix
    ./hardware/intel-graphics.nix
    ./hardware/fingerprint.nix
    ./hardware/bluetooth.nix

    ./services/printing.nix

    ./virtualisation/libvirt.nix
    ./virtualisation/gns3.nix

    ./programs/wireshark.nix
    ./programs/optical.nix
  ];
}
