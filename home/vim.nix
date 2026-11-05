{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible     # domyślny plugin HM – zostawiamy, bo podanie listy go nadpisuje
      vim-nix          # składnia, wcięcia i rozpoznawanie plików .nix
      gruvbox-material # schemat kolorów
    ];

    settings = {
      number = true;           # numery linii
      relativenumber = false;  # bez numerów względnych (to było to "przeskakiwanie")
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
    };

    extraConfig = ''
      syntax on
      filetype plugin indent on

      " Pełne kolory (Konsole je obsługuje)
      if has('termguicolors')
        set termguicolors
      endif

      " Podświetl tylko numer bieżącej linii, nie całą linię
      set cursorline
      set cursorlineopt=number

      " Gruvbox Material – opcje muszą być ustawione PRZED :colorscheme
      set background=dark
      let g:gruvbox_material_background = 'hard'     " najciemniejszy wariant ('medium', 'soft' = jaśniejsze)
      " Jeszcze ciemniejsze tło niż 'hard' (#1d2021); '#000000' = całkiem czarne
      let g:gruvbox_material_colors_override = {'bg0': ['#141617', '232']}
      let g:gruvbox_material_foreground = 'material'
      let g:gruvbox_material_enable_bold = 1
      " (nie włączaj g:gruvbox_material_better_performance – próbuje pisać do /nix/store)
      colorscheme gruvbox-material

      " Pliki .nix: wcięcie 2 spacje, linijka pomocnicza na 100 kolumnie
      autocmd FileType nix setlocal shiftwidth=2 tabstop=2 expandtab colorcolumn=100
    '';
  };
}
