{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Paweł";
        email = "343913832+pawel-zydek@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
