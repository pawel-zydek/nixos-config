{
  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      clickItemTo = "select";
    };

    # niski poziom: dowolny klucz z plików konfiguracyjnych KDE
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  };
}
