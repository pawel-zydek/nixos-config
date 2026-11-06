{
  programs.thunderbird = {
    enable = true;
    languagePacks = [ "pl" ];

    policies = {
      DisableTelemetry = true;
    };

    profiles.default = {
      isDefault = true;
      settings = {
        "mail.biff.show_tray_icon_always" = true; # Ikonka w zasobniku
        "mail.shell.checkDefaultClient" = false;
        "mailnews.start_page.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
      };
    };
  };
}
