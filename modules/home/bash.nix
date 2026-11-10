{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };

    historyControl = [ "ignoredups" "ignorespace" ];  # bez duplikatów, spacja na początku = nie zapisuj
    historySize = 10000;
  };
}
