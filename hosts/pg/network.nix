{ ... }:
{
  # hardware-configuration.nix włącza DHCP na wszystkich kartach, a tego nie chcemy
  networking.useDHCP = false;

  # Wi-Fi zostaje pod NetworkManagerem, resztą zarządza networkd lub libvirt
  networking.networkmanager.unmanaged = [
    "interface-name:enp2s0"        # karta w laptopie (br100)
    "interface-name:dock100"       # karta w stacji (br100)
    "interface-name:dock200"       # karta w stacji (br200)
    "interface-name:br100"
    "interface-name:br200"
    "interface-name:virbr*"        # NAT libvirta
    "interface-name:vnet*"         # karty uruchomionych VM
  ];

  # Otwarcie portów na interfejsie Wi-Fi
  networking.firewall.interfaces."wlp0s20f3" = {    # nazwa z `ip -br link`
    # Dla KDE Connect
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    # Dla Spotify Connect
    allowedTCPPorts = [ 57621 ];
    allowedUDPPorts = [ 5353 ];
  };

  services.resolved.enable = true;

  systemd.network = {
    enable = true;
    wait-online.enable = false;    # start nie czeka na kable ani mostki

    # Karty USB w stacji dokującej mają ścieżkowe nazwy dłuższe niż 15 znaków
    # (np. enp0s13f0u1u3u3u4), więc jądro zostawia im ethN, a N zależy od kolejności
    # wykrycia. Nadajemy im stałe nazwy po adresie MAC.
    links = {
      "10-dock100" = {
        matchConfig.PermanentMACAddress = "0c:37:96:bd:5b:b0";   # dawniej eth2
        linkConfig.Name = "dock100";
      };
      "10-dock200" = {
        matchConfig.PermanentMACAddress = "40:ae:30:9a:ec:8e";   # dawniej eth0
        linkConfig.Name = "dock200";
      };
    };

    netdevs = {
      "20-br100".netdevConfig = { Kind = "bridge"; Name = "br100"; };
      "21-br200".netdevConfig = { Kind = "bridge"; Name = "br200"; };
    };

    networks = {
      # Karta laptopa lub karta w stacji wchodzi do br100 i nie ma własnego IP
      # (nigdy nie są wpięte obie naraz)
      "20-eth100" = {
        matchConfig.Name = "enp2s0 dock100";
        networkConfig.Bridge = "br100";
        linkConfig.RequiredForOnline = "enslaved";
      };
      # adres hosta w sieci 10.100.0.0/16 (bez bramy)
      "20-br100" = {
        matchConfig.Name = "br100";
        address = [ "10.100.250.10/16" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;   # adres zostaje, gdy kabel jest wyjęty
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "no";
      };

      # Druga karta w stacji wchodzi do br200
      "21-eth200" = {
        matchConfig.Name = "dock200";
        networkConfig.Bridge = "br200";
        linkConfig.RequiredForOnline = "enslaved";
      };
      # adres hosta w sieci 10.200.0.0/16 (bez bramy)
      "21-br200" = {
        matchConfig.Name = "br200";
        address = [ "10.200.250.10/16" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "no";
      };
    };
  };
}
