{ ... }:
{
  # hardware-configuration.nix włącza DHCP na wszystkich kartach, a tego nie chcemy
  networking.useDHCP = false;

  # Wi-Fi zostaje pod NetworkManagerem, resztą zarządza networkd lub libvirt
  networking.networkmanager.unmanaged = [
    "interface-name:enp2s0"        # ETH1
    "interface-name:enp3s0"        # ETH2
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

    netdevs = {
      "20-br100".netdevConfig = { Kind = "bridge"; Name = "br100"; };
      "21-br200".netdevConfig = { Kind = "bridge"; Name = "br200"; };
    };

    networks = {
      # ETH1 wchodzi do mostka i nie ma własnego IP
      "20-eth100" = {
        matchConfig.Name = "enp3s0";
        networkConfig.Bridge = "br100";
        linkConfig.RequiredForOnline = "enslaved";
      };
      # adres hosta w sieci 10.100.0.0/16 (bez bramy)
      "20-br100" = {
        matchConfig.Name = "br100";
        address = [ "10.100.0.20/16" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;   # adres zostaje, gdy kabel jest wyjęty
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "no";
      };

      # ETH2 wchodzi do mostka
      "21-eth200" = {
        matchConfig.Name = "enp4s0";
        networkConfig.Bridge = "br200";
        linkConfig.RequiredForOnline = "enslaved";
      };
      # adres hosta w sieci 10.200.0.0/16 (bez bramy)
      "21-br200" = {
        matchConfig.Name = "br200";
        address = [ "10.200.0.20/16" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "no";
      };
    };
  };
}
