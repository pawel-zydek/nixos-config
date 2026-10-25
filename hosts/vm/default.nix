{ pkgs, ... }:
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

  # agent sesji SPICE (rozdzielczość, schowek PG -> VM)
  # autostart z pakietu nie działa w Plasmie 6, więc własna usługa użytkownika
  systemd.user.services.spice-vdagent = {
    description = "Agent sesji SPICE";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      Restart = "on-failure";
    };
  };

  # SSH - dostęp z laptopa (port 22 otwiera się w zaporze automatycznie)
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # klucz publiczny z laptopa (pg)
  users.users.pawel.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlKrUMXtKlnlbGQgiioga7bd/StVWdbAwz+1jJ7+vQO pawel@nixos-pg"
  ];

}
