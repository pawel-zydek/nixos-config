{ ... }:
{
  # Konto systemowe. Dodatkowe grupy (libvirtd, wireshark, ...) dopisują
  # moduły, które ich potrzebują.
  users.users.pawel = {
    isNormalUser = true;
    description = "Paweł Żydek";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  networking.networkmanager.enable = true;
}
