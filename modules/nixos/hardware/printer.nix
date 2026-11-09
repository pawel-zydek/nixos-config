{ pkgs, ... }:
{
  # Druk
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # Wykrywanie drukarki w sieci
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Skaner
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  services.udev.packages = [ pkgs.sane-airscan ];

  users.users.pawel.extraGroups = [ "scanner" "lp" ];

  # Program do skanowania
  environment.systemPackages = [ pkgs.kdePackages.skanpage ];
}
