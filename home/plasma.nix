{
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";          # ciemne panele, menu, widżety Plasmy
      colorScheme = "BreezeLight";    # jasne okna aplikacji
      iconTheme = "breeze";           # ciemne ikony, widoczne na jasnym tle
      clickItemTo = "select";
      #wallpaper = ./wallpapers/moja.jpg;
      #wallpaperFillMode = "preserveAspectCrop";
    };



    # niski poziom: dowolny klucz z plików konfiguracyjnych KDE
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  };
}
