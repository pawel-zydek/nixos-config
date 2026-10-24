{
  programs.plasma = {
    enable = true;

    # Obszar roboczy
    workspace = {
      theme = "breeze-dark";          # ciemne panele, menu, widżety Plasmy
      colorScheme = "BreezeClassic";  # jasne okna z ciemną belką tytułową
      iconTheme = "breeze";           # ciemne ikony, widoczne na jasnym tle
      clickItemTo = "select";
      wallpaper = ./Wallpapers/Inne/Beskidy_1.JPG;
      wallpaperFillMode = "preserveAspectCrop";
    };

    # Ekran blokady
    kscreenlocker.appearance = {
      wallpaper = ./Wallpapers/NixOS/NixOS-Stripes-Logo.png;
    };

    # Ustawienia panelu Plasmy
    panels = [
      {
        location = "bottom";
        floating = true;
        height = 44;

        # Elementy na panelu:
        widgets = [
          # Uruchamiacz programów
          { kickoff.icon = "nix-snowflake-white"; }

          # Ikonki na pasku zadań
          {
            iconTasks.launchers = [
              "applications:org.kde.dolphin.desktop"
              "applications:firefox.desktop"
              "applications:thunderbird.desktop"
              "applications:obsidian.desktop"
              "applications:spotify.desktop"
              "applications:virt-manager.desktop"
            ];
          }

          # Zarezerwowana przestrzeń
          "org.kde.plasma.panelspacer"

          # Monitor systemu - CPU
          {
            name = "org.kde.plasma.systemmonitor.cpu";
            config = {
              CurrentPreset = "org.kde.plasma.systemmonitor";
              Appearance = {
                chartFace = "org.kde.ksysguard.piechart";
                title = "Całkowite użycie procesora";
              };
              SensorColors."cpu/all/usage" = "61,174,233";
              Sensors = {
                highPrioritySensorIds = ''["cpu/all/usage"]'';
                totalSensors = ''["cpu/all/usage"]'';
              };
            };
          }

          # Monitor systemu - RAM
          {
            name = "org.kde.plasma.systemmonitor.memory";
            config = {
              CurrentPreset = "org.kde.plasma.systemmonitor";
              Appearance = {
                chartFace = "org.kde.ksysguard.piechart";
                title = "Wykorzystanie pamięci";
              };
              SensorColors."memory/physical/used" = "61,174,233";
              Sensors = {
                highPrioritySensorIds = ''["memory/physical/used"]'';
                lowPrioritySensorIds = ''["memory/physical/total"]'';
                totalSensors = ''["memory/physical/usedPercent"]'';
              };
            };
          }

          # Monitor systemu - Sieć
          {
            name = "org.kde.plasma.systemmonitor.net";
            config = {
              CurrentPreset = "org.kde.plasma.systemmonitor";
              Appearance = {
                chartFace = "org.kde.ksysguard.linechart";
                title = "Szybkość sieci";
              };
              SensorColors = {
                "network/all/download" = "61,174,233";
                "network/all/upload" = "233,120,61";
              };
              Sensors.highPrioritySensorIds = ''["network/all/download","network/all/upload"]'';
            };
          }

          # Tacka systemowa
          "org.kde.plasma.systemtray"

          # Zegarek
          "org.kde.plasma.digitalclock"

          # Pokaż pulpit
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # Reguły okien KWin: przypięcie okna do właściwego pliku .desktop (ikona na pasku)
    window-rules = [
      {
        description = "Obsidian - poprawna ikona";
        match.window-class = {
          value = "obsidian";      # fragment klasy okna z kroku 1
          type = "substring";
          match-whole = false;
        };
        apply.desktopfile = {
          value = "obsidian";      # nazwa pliku obsidian.desktop bez rozszerzenia
          apply = "force";
        };
      }
    ];

    # niski poziom: dowolny klucz z plików konfiguracyjnych KDE
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  };
}
