{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      user = {
        name = "Paweł";
        email = "343913832+pawel-zydek@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      # token trzymany w KWallet zamiast jawnym tekstem w ~/.git-credentials
      credential.helper = "libsecret";
    };
  };
}
