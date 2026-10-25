{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/kvm.nix
    ../../modules/wireshark.nix
  ];

  networking.hostName = "nixos-vm";
  networking.hostId = "379d459b";          # własne 8 znaków hex
  my.disk = "/dev/disk/by-id/virtio-nixosvm"; # Nadać numer seryjny dysku "nixosvm"

  # gość KVM/QEMU
  services.qemuGuest.enable = true;          # wyłączanie/stan VM z poziomu virt-managera
  services.spice-vdagentd.enable = true;     # schowek i automatyczna rozdzielczość
}
