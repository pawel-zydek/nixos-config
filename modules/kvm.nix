{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;              # emulowany TPM 2.0 (wymóg Windows 11)
    };
  };

  programs.virt-manager.enable = true;
  programs.dconf.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  users.users.pawel.extraGroups = [ "libvirtd" ];
}
