{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;

    # Natywne programy, z którymi rozmawiają rozszerzenia (np. Integracja przeglądarki Plazmy)
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

    languagePacks = [ "pl" ];

    policies = {
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
    };

    profiles.default = {
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
        "intl.accept_languages" = "pl, en-US, en";
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };
    };
  };
}
