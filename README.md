# Konfiguracja systemu NixOS
Będę rozwijał dla siebie dwie wersje:
1. Dla wirtualnej maszyny (`vm`) - aktualne testy
2. Dla laptopa (`pg`) - Przygotowanie do normalnej pracy

Jest to repozytorium do nauki.

## Struktura repozytorium

```
flake.nix                 # wejścia (nixpkgs, disko, home-manager, plasma-manager) i hosty
flake.lock                # przypięte wersje wejść
modules/
  common.nix              # wspólne: boot, ZFS, Plasma, użytkownik, pakiety systemowe
  disko-zfs.nix           # układ dysku: ESP 1G + szyfrowana pula ZFS rpool
  laptop.nix              # firmware, grafika Intel, czytnik odcisków, Bluetooth, fwupd, drukowanie
  kvm.nix                 # libvirt + virt-manager + TPM (Windows 11)
  wireshark.nix, optical.nix
hosts/
  vm/                     # maszyna testowa Hyper-V
  pg/                     # laptop (sieć, mostki, dodatkowe datasety ZFS)
home/                     # Home Manager: git, vim, firefox, thunderbird, plasma, ...
```

## Układ dysku na laptopie

| Partycja / dataset | Punkt montowania | Uwagi |
|---|---|---|
| ESP (1 GB, FAT32) | `/boot` | systemd-boot |
| `rpool` (reszta dysku) | — | ZFS, szyfrowanie aes-256-gcm, hasło przy starcie |
| `rpool/root` | `/` | |
| `rpool/nix` | `/nix` | |
| `rpool/var` | `/var` | |
| `rpool/vm` | `/var/lib/libvirt/images` | obrazy VM (Windows 11), `recordsize=64K` |
| `rpool/home` | `/home` | snapshoty sanoid (24 h / 7 dni / 3 mies.) |
| `rpool/reserved` | — | rezerwa 50 GB, żeby pula nigdy się nie zapełniła |

Brak partycji swap — używany jest zram (hibernacja nie jest dostępna, ZFS jej nie wspiera).

---

# Sposób instalacji (laptop, host `pg`)

> **Uwaga:** krok 7 kasuje **cały** dysk wskazany w `my.disk`.

## 0. Przygotowanie

1. Pobierz **minimalny** obraz NixOS 26.05 z <https://nixos.org/download/> (wersja *Minimal ISO image*, 64-bit Intel/AMD).
   Nie wybieraj wariantu „new kernel, no ZFS” – nie ma w nim ZFS.
2. Zapisz obraz na pendrive (np. KDE ISO Image Writer, Rufus w trybie DD, albo `dd`).
3. Ustawienia UEFI/BIOS laptopa:
   - **Secure Boot – wyłączony** (systemd-boot nie jest podpisany),
   - **Intel VT-x i VT-d (lub AMD-V / IOMMU) – włączone** (potrzebne do KVM i Windows 11),
   - **Intel VMD / RST – wyłączony**, tryb dysku **AHCI** (inaczej instalator może nie widzieć dysku NVMe),
   - uruchamianie z USB w trybie UEFI.

## 1. Start instalatora i klawiatura

Po uruchomieniu z pendrive’a:

```bash
sudo -i                 # dalej wszystko jako root
loadkeys pl2            # polska klawiatura w konsoli
export NIX_CONFIG="experimental-features = nix-command flakes"
```

`NIX_CONFIG` włącza flakes na czas tej sesji – bez tego polecenia `nix` nie zadziałają z repozytorium.

## 2. Połączenie z Wi-Fi

Minimalny instalator ma NetworkManagera, więc działa `nmcli` (lub tekstowy kreator `nmtui`).

```bash
nmcli radio wifi on                       # na wszelki wypadek
nmcli device wifi list                    # lista dostępnych sieci
nmcli device wifi connect "NAZWA_SIECI" --ask    # zapyta o hasło
ping -c 3 nixos.org                       # test połączenia
```

- Sieć ukryta: `nmcli device wifi connect "NAZWA_SIECI" password "HASŁO" hidden yes`
- Nie widać karty Wi-Fi? Sprawdź `rfkill list` i ewentualnie `rfkill unblock all`.
- Kabel Ethernet działa od razu (DHCP), jeśli jest pod ręką.

## 3. (Opcjonalnie) Praca przez SSH z innego komputera

Dzięki temu można wklejać polecenia z tej instrukcji.

```bash
passwd nixos            # tymczasowe hasło dla użytkownika instalatora
ip -br addr             # adres IP laptopa
```

Na drugim komputerze: `ssh nixos@ADRES_IP`, potem znowu `sudo -i` oraz `export NIX_CONFIG=...` z kroku 1.

## 4. Pobranie repozytorium

```bash
git clone https://github.com/pawel-zydek/nixos-config /tmp/nixos-config
cd /tmp/nixos-config
```

## 5. Uzupełnienie danych sprzętowych

### 5a. Dysk

```bash
ls -l /dev/disk/by-id/ | grep -v part
```

Wybierz wpis wskazujący na dysk NVMe, najlepiej w postaci `nvme-<MODEL>_<NUMER_SERYJNY>` (nie `nvme-eui...`).
Wpisz go w `hosts/pg/default.nix`:

```bash
vim hosts/pg/default.nix
# my.disk = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_XXXXXXXX";
```

### 5b. Nazwy kart sieciowych

```bash
ip -br link
```

Porównaj nazwy z `hosts/pg/network.nix` (`enp3s0`, `enp4s0`, `wlp0s20f3`) i popraw, jeśli są inne.

### 5b'. Czytnik linii papilarnych

```bash
nix-shell -p usbutils --run lsusb | grep -i -E "finger|goodix|synaptics|elan|validity|fpc"
```

Zapisz identyfikator `ID xxxx:yyyy` i sprawdź go na liście obsługiwanych urządzeń:
<https://fprint.freedesktop.org/supported-devices.html>.
Jeśli jest na liście, nic nie zmieniasz. Jeśli nie, w `modules/laptop.nix` odkomentuj sekcję
`services.fprintd.tod` i wybierz sterownik (`libfprint-2-tod1-goodix`, `-goodix-550a`, `-elan`, `-broadcom`, `-vfs0090`).

### 5c. Plik hardware-configuration.nix

`--no-filesystems`, bo systemy plików opisuje disko.

```bash
nixos-generate-config --no-filesystems --show-hardware-config > hosts/pg/hardware-configuration.nix
```

### 5d. Dodanie zmian do gita

Flake widzi **tylko pliki śledzone przez gita** – bez tego kroku zmiany zostaną pominięte.

```bash
git add -A
git status
```

### 5e. Szybki test konfiguracji

```bash
nix eval .#nixosConfigurations.pg.config.system.build.toplevel.drvPath
```

Jeśli wypisze ścieżkę `/nix/store/...drv`, konfiguracja jest poprawna. Błąd pokaże plik i linię.

## 6. Ostatnia kontrola przed formatowaniem

```bash
grep my.disk hosts/pg/default.nix
ls -l $(grep -o '/dev/disk/by-id/[^"]*' hosts/pg/default.nix)   # musi wskazywać na nvme0n1 (lub właściwy dysk)
```

## 7. Partycjonowanie i formatowanie (disko)

```bash
nix run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#pg
```

- disko poprosi o potwierdzenie usunięcia danych,
- potem **dwa razy o hasło szyfrowania ZFS** – to hasło będzie wpisywane przy każdym starcie, nie zgub go.

Sprawdzenie:

```bash
zpool status rpool
zfs list
findmnt -R /mnt
```

Powinny być zamontowane `/mnt`, `/mnt/boot`, `/mnt/nix`, `/mnt/var`, `/mnt/var/lib/libvirt/images`, `/mnt/home`.

## 8. Instalacja

```bash
nixos-install --flake .#pg --no-root-passwd
```

Pobiera kilka GB, więc trochę potrwa. `--no-root-passwd` – root bez hasła logowania, administrujemy przez `sudo` (grupa `wheel`).

## 9. Czynności po instalacji (jeszcze w instalatorze)

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

## 10. Odmontowanie i restart

```bash
umount -Rl /mnt
zpool export -a        # ważne: bez eksportu pula może nie zaimportować się przy starcie
reboot
```

Wyjmij pendrive.

> Jeśli mimo to start zatrzyma się z komunikatem, że pula była używana przez inny system,
> w konsoli awaryjnej wykonaj jednorazowo `zpool import -f rpool` i uruchom ponownie.

## 11. Pierwsze uruchomienie

1. Wpisz hasło ZFS.
2. Zaloguj się w SDDM jako `pawel`.
3. Wi-Fi powinno połączyć się samo (krok 9); jeśli nie – applet sieci w zasobniku.
4. Zapisz zmiany w repozytorium (głównie `hardware-configuration.nix` i `my.disk`):

```bash
cd ~/nixos-config
git status
git add -A
git commit -m "Laptop: hardware-configuration i dysk"
git push
```

Przy pierwszym `git push` podaj login GitHub i **token** (Personal Access Token) zamiast hasła – zostanie zapamiętany w KWallet.

5. Odcisk palca: *Ustawienia systemowe → Użytkownicy → Konfiguruj uwierzytelnianie odciskiem palca*
   (lub w terminalu `fprintd-enroll`, test: `fprintd-verify`).
   Odcisk działa w `sudo` i na ekranie blokady; logowanie w SDDM celowo zostaje na haśle (odblokowuje KWallet).
6. Sprawdzenie sprzętowego dekodowania wideo: `nix-shell -p libva-utils --run vainfo` – powinien pokazać sterownik `iHD`.

---

# Codzienna praca

```bash
cd ~/nixos-config

# po zmianie plików konfiguracji
git add -A
sudo nixos-rebuild switch --flake .#pg

# aktualizacja systemu
nix flake update
sudo nixos-rebuild switch --flake .#pg
nvd diff /run/booted-system /run/current-system    # co się zmieniło
git commit -am "Aktualizacja flake.lock" && git push

# test bez zapisywania jako domyślna generacja
sudo nixos-rebuild test --flake .#pg
```

Stara generacja zawsze jest dostępna w menu systemd-boot przy starcie.

## Snapshoty ZFS

```bash
zfs list -t snapshot                       # lista snapshotów (sanoid robi je dla /home)
sudo zfs snapshot rpool/root@przed-zmiana  # ręczny snapshot
ls /home/.zfs/snapshot/                    # podgląd plików ze snapshotów
```

## Firmware

```bash
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

---

# Maszyna wirtualna Windows 11

1. Pobierz ISO Windows 11 oraz sterowniki VirtIO (`virtio-win.iso`, <https://github.com/virtio-win/virtio-win-pkg-scripts>).
   Skopiuj oba do `/var/lib/libvirt/images/` (`sudo cp ...`).
2. Uruchom sieć NAT libvirta (raz):

   ```bash
   sudo virsh net-start default
   sudo virsh net-autostart default
   ```

3. virt-manager → *Nowa maszyna* → *Lokalny nośnik* → ISO Windows 11.
   RAM 8 GB, 4 rdzenie, dysk 100+ GB (zostanie utworzony w `/var/lib/libvirt/images`).
4. Zaznacz **„Dostosuj konfigurację przed instalacją”**:
   - *Przegląd* → Firmware: **UEFI z Secure Boot** (`OVMF_CODE.secboot`), Chipset: Q35,
   - *Dodaj sprzęt* → **TPM**, model CRB, wersja 2.0 (emulowany),
   - Dysk: magistrala **VirtIO**, Karta sieciowa: model **virtio**,
   - *Dodaj sprzęt* → *Pamięć masowa* → CD-ROM z `virtio-win.iso`.
5. Przy wyborze dysku w instalatorze Windows: *Załaduj sterownik* → napęd z virtio-win → `viostor\w11\amd64`.
6. Po instalacji uruchom `virtio-win-guest-tools.exe` z płyty virtio-win.
7. Sieć: NAT (`default`) albo mostek `br100` / `br200`, aby VM była w sieci 10.100/10.200.

Snapshot obrazu przed dużą aktualizacją Windows (przy wyłączonej VM):

```bash
sudo zfs snapshot rpool/vm@przed-aktualizacja
sudo zfs rollback rpool/vm@przed-aktualizacja    # powrót, jeśli coś pójdzie źle
```

---

# Rozwiązywanie problemów

| Objaw | Rozwiązanie |
|---|---|
| `fprintd-enroll`: „No devices available” | czytnik wymaga sterownika TOD – patrz krok 5b' |
| `vainfo` pokazuje błąd / `i965` | stary procesor (przed Broadwell): zamień na `intel-vaapi-driver` i `LIBVA_DRIVER_NAME = "i965"` |
| Instalator nie widzi dysku NVMe | Wyłącz Intel VMD/RST w UEFI (tryb AHCI) |
| Brak karty Wi-Fi w `nmcli` | `rfkill unblock all`; sprawdź `ip -br link` |
| `nix` nie zna `flake` / `run` | `export NIX_CONFIG="experimental-features = nix-command flakes"` |
| Zmiany w plikach są ignorowane | `git add -A` – flake widzi tylko pliki w gicie |
| Start zatrzymuje się na imporcie `rpool` | w konsoli awaryjnej `zpool import -f rpool`, potem `reboot` |
| System nie startuje po zmianie | wybierz poprzednią generację w menu systemd-boot |
