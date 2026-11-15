# Konfiguracja systemu NixOS

Konfiguracja stacji roboczej (host `nixos-pg`): 
NixOS + KDE Plasma 6 na szyfrowanym ZFS,
Home Manager jako moduł NixOS.

## Struktura repozytorium

```
flake.nix                       # Wejścia (nixpkgs, disko, home-manager, plasma-manager)
flake.lock                      # Przypięte wersje wejść
hosts/
  pg/
    default.nix                 # Tożsamość hosta + lista włączonych funkcji (my.*.enable)
    hardware-configuration.nix  # Konfiguracja sprzętu
    network.nix                 # Wi-Fi, mostki br100/br200, karty w stacji dokującej
    disko.nix                   # Układ dysku: ESP + szyfrowana pula rpool z datasetami
modules/
  nixos/                        # Moduły systemowe; default.nix importuje wszystkie
    core/                       # Nix, boot, locale, użytkownik, sieć, pakiety, Home Manager
    storage/                    # Systemy plików: zfs, ntfs
    desktop/                    # Plasma, Audio
    hardware/                   # Firmware, Intel-graphics, Fingerprint, Bluetooth
    services/                   # Printing (druk, skaner, mDNS)
    virtualisation/             # Obsługa wirtualizacji: libvirt, gns3
    programs/                   # Dodatkowe programy: wireshark, optical, steam
  home/                         # Moduły Home Managera: git, vim, bash, firefox, plasma, ...
users/
  pawel.nix                     # Które moduły z modules/home/ dostaje użytkownik
assets/
  wallpapers/                   # Tapety (pulpit, ekran blokady, SDDM)
```

Moduły spoza `core/` nic nie robią, dopóki host ich nie włączy w `hosts/pg/default.nix`:

```nix
my.virtualisation.gns3.enable = true;
```
Aby stworzyć nowy moduł:
należy utworzyć plik w odpowiednim katalogu `modules/nixos/`, dopisać go do
`modules/nixos/default.nix` i włączyć w hoście. 

Formatowanie całego repo: `nix fmt`.

## Układ dysku na stacji roboczej

| Partycja / dataset | Punkt montowania | Uwagi |
|---|---|---|
| ESP (1 GB, FAT32) | `/boot` | systemd-boot |
| `rpool` (reszta dysku) | — | ZFS, szyfrowanie aes-256-gcm, hasło przy starcie |
| `rpool/root` | `/` | |
| `rpool/nix` | `/nix` | |
| `rpool/var` | `/var` | |
| `rpool/vm` | `/var/lib/libvirt/images` | obrazy VM (Windows 11), `recordsize=64K` |
| `rpool/vm-lab` | `/var/lib/libvirt/vm-lab` | dyski maszyn laboratoryjnych, `recordsize=64K` |
| `rpool/home` | `/home` | snapshoty sanoid (24 h / 7 dni / 3 mies.) |
| `rpool/reserved` | — | rezerwa 50 GB, żeby pula nigdy się nie zapełniła |

Brak partycji swap — używany jest zram (hibernacja nie jest dostępna, ZFS jej nie wspiera).

---

# Sposób instalacji

## 0. Przygotowanie

1. Do instalacji wystarczy **minimalny** obraz NixOS 64-bit Intel/AMD. (Kernel LTS z obsługą ZFS)
2. Obraz zapisać na pendrive w trybie DD.
3. Ustawienia UEFI/BIOS laptopa:
   - **Secure Boot – wyłączony** (systemd-boot nie jest podpisany),
   - **Intel VT-x i VT-d (lub AMD-V / IOMMU) – włączone** (potrzebne do KVM),
   - **Intel VMD / RST – wyłączony**, tryb dysku **AHCI** (inaczej instalator może nie widzieć dysku NVMe),
   - uruchamianie z USB w trybie UEFI.

## 1. Start instalatora

Po uruchomieniu instalatora:

```bash
sudo -i                 # dalej wszystko jako root
loadkeys pl2            # polska klawiatura w konsoli
export NIX_CONFIG="experimental-features = nix-command flakes"
```
`NIX_CONFIG` włącza flakes na czas tej sesji – bez tego polecenia `nix` nie zadziałają z repozytorium.

Jest możliwość pracy przez SSH. Należy nadać hasło użytkownikowi 'nixos'
```bash
passwd nixos            # tymczasowe hasło dla użytkownika instalatora
```
Potem sprawdzić adres IP i połączyć się przez SSH.

## 2. Połączenie z siecią

DHCP po przewodzie działa z automatu. 
W przypadku **WiFi**:
Minimalny instalator ma NetworkManagera, więc działa `nmcli`.
```bash
nmcli radio wifi on                       # na wszelki wypadek
nmcli device wifi list                    # lista dostępnych sieci
nmcli device wifi connect "NAZWA_SIECI" --ask    # zapyta o hasło
ping -c 3 nixos.org                       # test połączenia
```

## 3. Pobranie repozytorium

```bash
git clone https://github.com/pawel-zydek/nixos-config /tmp/nixos-config
cd /tmp/nixos-config
```

## 4. Uzupełnienie danych sprzętowych

### 4a. Dysk

Odnalezienie dysku laptopa:
```bash
ls -l /dev/disk/by-id/ | grep -v part
```
Najlepiej w postaci `nvme-<MODEL>_<NUMER_SERYJNY>` (nie `nvme-eui...`).
Należy go wpisać do `hosts/pg/disko.nix`:

```bash
vim hosts/pg/disko.nix
# device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_XXXXXXXX";
```

### 4b. Nazwy kart sieciowych

```bash
ip -br link # Pokazuje MAC każdej karty sieciowej
```
Należy sprawdzić `hosts/pg/network.nix` i uzupełnić/podmienić nazwy kart sieciowych.

### 4c. Plik hardware-configuration.nix

Generowanie pliku z konfiguracją sprzętową.
`--no-filesystems`, bo systemy plików opisuje disko.

```bash
nixos-generate-config --no-filesystems --show-hardware-config > hosts/pg/hardware-configuration.nix
```

### 4d. Dodanie zmian do gita

Flake widzi **tylko pliki śledzone przez gita** – bez tego kroku zmiany zostaną pominięte.

```bash
git add -A
git status
```

## 5. Partycjonowanie i formatowanie (disko)

> **Uwaga:** krok kasuje **cały** dysk wskazany w `hosts/pg/disko.nix` (`disk.main.device`).
```bash
nix run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#nixos-pg
```

- disko poprosi o potwierdzenie usunięcia danych,
- potem **dwa razy o hasło szyfrowania ZFS** – to hasło będzie wpisywane przy każdym starcie.

Sprawdzenie:

```bash
zpool status rpool
zfs list
findmnt -R /mnt
```

Powinny być zamontowane `/mnt`, `/mnt/boot`, `/mnt/nix`, `/mnt/var`, `/mnt/var/lib/libvirt/images`,
`/mnt/var/lib/libvirt/vm-lab`, `/mnt/home`.

## 6. Instalacja

```bash
nixos-install --flake .#nixos-pg --no-root-passwd
```

`--no-root-passwd` – root bez hasła logowania, administracja przez `sudo` (grupa `wheel`).

## 7. Czynności po instalacji (jeszcze w instalatorze)

```bash
# hasło użytkownika pawel
nixos-enter --root /mnt -c 'passwd pawel'

# przeniesienie zapisanej sieci Wi-Fi do nowego systemu
mkdir -p /mnt/etc/NetworkManager/system-connections
cp /etc/NetworkManager/system-connections/*.nmconnection /mnt/etc/NetworkManager/system-connections/
chmod 600 /mnt/etc/NetworkManager/system-connections/*

# kopia repozytorium (z hardware-configuration.nix) do katalogu domowego
cp -r /tmp/nixos-config /mnt/home/pawel/
chown -R 1000:100 /mnt/home/pawel      # 1000 = pawel, 100 = grupa users
```

## 8. Odmontowanie i restart

```bash
umount -Rl /mnt
zpool export -a        # ważne: bez eksportu pula może nie zaimportować się przy starcie
reboot
```

## 9. Pierwsze uruchomienie

Zapisanie zmian w repozytorium na githubie
```bash
cd ~/nixos-config
git status
git add -A
git commit -m "Laptop: hardware-configuration i dysk"
git push
```

---
