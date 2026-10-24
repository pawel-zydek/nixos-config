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
        "mail.shell.checkDefaultClient" = false;
        "mailnews.start_page.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "mail.closeToTray" = true;
      # "mail.closeToTray.startInTray" = true;
      };
    };
  };
}
