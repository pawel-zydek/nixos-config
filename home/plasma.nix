{
  programs.plasma = {
    enable = true;

    # Obszar roboczy
    workspace = {
      theme = "breeze-dark";          # ciemne panele, menu, widżety Plasmy
      colorScheme = "BreezeClassic";  # jasne okna z ciemną belką tytułową
      iconTheme = "breeze";           # ciemne ikony, widoczne na jasnym tle
      clickItemTo = "select";
      wallpaper = ./Wallpapers/NixOS-Gradient-grey.png;
      wallpaperFillMode = "preserveAspectCrop";
    };

    # Ekran blokady
    kscreenlocker.appearance = {
      wallpaper = ./Wallpapers/NixOS-Stripes-logo.png;
    };

    # Ustawienia panelu Plasmy
    panels = [
      {
        location = "bottom";
        floating = true;
        widgets = [
          {
            kickoff = {
              icon = "nix-snowflake-white";
            };
          }
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];


    # niski poziom: dowolny klucz z plików konfiguracyjnych KDE
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  };
}
