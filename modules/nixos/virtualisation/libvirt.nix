{ config, lib, pkgs, ... }:
let
  cfg = config.my.virtualisation.libvirt;
in
{
  options.my.virtualisation.libvirt.enable = lib.mkEnableOption "KVM/libvirt z virt-managerem i TPM (Windows 11)";

  config = lib.mkIf cfg.enable {
    # Zagnieżdżona wirtualizacja (KVM w VM) jest domyślnie włączona od jądra 4.20;
    # kontrola: cat /sys/module/kvm_intel/parameters/nested  ->  Y

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;          # tylko architektura hosta (domyślny pkgs.qemu jest dużo większy)
        swtpm.enable = true;              # emulowany TPM 2.0 (wymóg Windows 11)
        vhostUserPackages = [ pkgs.virtiofsd ];   # udostępnianie katalogów hosta (virtiofs)
      };
    };

    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

    users.users.${config.my.user}.extraGroups = [ "libvirtd" ];
  };
}
