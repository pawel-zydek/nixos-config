{ config, lib, pkgs, ... }:
let
  cfg = config.my.virtualisation.libvirt;
in
{
  options.my.virtualisation.libvirt.enable = lib.mkEnableOption "KVM/libvirt z virt-managerem i TPM (Windows 11)";

  config = lib.mkIf cfg.enable {
    # Zagnieżdżona wirtualizacja: VM-ki na laptopie mogą same uruchamiać KVM
    boot.extraModprobeConfig = "options kvm_intel nested=1";

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;              # emulowany TPM 2.0 (wymóg Windows 11)
        vhostUserPackages = [ pkgs.virtiofsd ];   # udostępnianie katalogów hosta (virtiofs)
      };
    };

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

    users.users.pawel.extraGroups = [ "libvirtd" ];
  };
}
