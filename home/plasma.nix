{
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";          # ciemne panele, menu, widżety Plasmy
      colorScheme = "BreezeClassic";  # jasne okna z ciemną belką tytułową
      iconTheme = "breeze";           # ciemne ikony, widoczne na jasnym tle
      clickItemTo = "select";
      wallpaper = ./Wallpapers/NixOS-Gradient-grey.png;
      wallpaperFillMode = "preserveAspectCrop";
    };



    # niski poziom: dowolny klucz z plików konfiguracyjnych KDE
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  };
}
