{ pkgs, lib, ... }:
{
  # GNS3: GUI uruchamia własny lokalny serwer (gns3server) z uprawnieniami użytkownika.
  # Program szuka vpcs, dynamips, ubridge i qemu w PATH, więc nic nie trzeba wskazywać ręcznie.
  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server          # lokalny serwer uruchamiany przez GUI
    dynamips             # emulator routerów Cisco (obrazy IOS we własnym zakresie)
    vpcs                 # proste wirtualne PC
    (lib.lowPrio inetutils)  # telnet - konsole węzłów (VPCS, routery); lowPrio: nie zasłania ping/hostname
    # ubridge NIE jest tu dodany: używamy wersji z uprawnieniami z /run/wrappers/bin
  ];

  # uBridge łączy węzły ze sobą oraz z kartami hosta (węzeł Cloud, przechwytywanie ruchu).
  # Potrzebuje uprawnień do sieci, ale nie całego roota - wystarczą capabilities.
  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "root";
    group = "ubridge";
    permissions = "u=rwx,g=rx,o=";       # uruchomić mogą tylko członkowie grupy ubridge
  };
  users.groups.ubridge = { };

  # ubridge - uruchamianie wrappera, kvm - przyspieszenie węzłów QEMU
  users.users.pawel.extraGroups = [ "ubridge" "kvm" ];

  # moduł tun do interfejsów TAP (ładuje go też libvirt, tu dla pewności)
  boot.kernelModules = [ "tun" ];
}
