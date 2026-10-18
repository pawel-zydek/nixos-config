{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
    };
    extraConfig = ''
      syntax on
      set mouse=a
    '';
  };
}
