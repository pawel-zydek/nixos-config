{ ... }:
{
  # agent SSH jako usługa użytkownika - startuje z sesją, ustawia SSH_AUTH_SOCK
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;          # nowa forma ustawień w Home Managerze 26.05
    settings."*" = {
      AddKeysToAgent = "yes";             # klucz trafia do agenta przy pierwszym użyciu
    };
  };
}
