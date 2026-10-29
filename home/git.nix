{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Paweł";
        email = "343913832+pawel-zydek@users.noreply.github.com";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      # token trzymany w KWallet zamiast jawnym tekstem w ~/.git-credentials
      credential.helper = "libsecret";
    };
  };
}
