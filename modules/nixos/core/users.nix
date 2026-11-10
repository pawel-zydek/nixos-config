{ config, lib, ... }:
{
  options.my.user = lib.mkOption {
    type = lib.types.str;
    default = "pawel";
    description = "Login głównego użytkownika. Moduły dopisują go do swoich grup.";
  };

  config = {
    # Konto systemowe. Dodatkowe grupy (libvirtd, wireshark, ...) dopisują
    # moduły, które ich potrzebują.
    users.users.${config.my.user} = {
      isNormalUser = true;
      description = "Paweł Żydek";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
}
