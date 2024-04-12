{ inputs, pkgs, ... }: {
  imports = [
    ./lsp.nix
  ];
  programs.nixvim = {
    enable = true;
    enableMan = true; # install man pages for nixvim options

    clipboard.register = "unnamedplus"; # use system clipboard instead of internal registers

    # TODO: nixvim: gruvbox-material
    colorschemes = {
      catppuccin = {
        enable = true;
        flavour = "macchiato";
        transparentBackground = true;
        integrations = {
          alpha = true;
          noice = true;
          which_key = true;
          neotree = true;
          treesitter = true;
        };
      };
    };
    colorscheme = "catppuccin";

    opts = {
      # # Lua reference:
      # vim.o behaves like :set
      # vim.go behaves like :setglobal
      # vim.bo for buffer-scoped options
      # vim.wo for window-scoped options (can be double indexed)

      #
      # ========= General Appearance =========
      #
      hidden = true; # Makes vim act like all other editors, buffers can exist in the background without being in a window. http://items.sjbach.com/319/configuring-vim-right
      number = true; # show line numbers
      relativenumber = true; # show relative linenumbers
      laststatus = 2; # laststatus of 2 is required for lightline
      history = 1000; # Store lots of :cmdline history
      showcmd = true; # Show incomplete cmds down the bottom
      showmode = true; # Show current mode down the bottom
      autoread = true; # Reload files changed outside vim
      lazyredraw = true; # Redraw only when needed
      showmatch = true; # highlight matching braces
      ruler = true; # show current line and column
      visualbell = true; # No sounds

      listchars = "trail:·"; # Display tabs and trailing spaces visually

      wrap = false; # Don't wrap lines
      linebreak = true; # Wrap lines at convenient points

      # ========= Font =========
      guifont = "RobotoMono:h9"; # fontname:fontsize

      # ========= Cursor =========
      guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n-v-i:blinkon0";

      # ========= Redirect Temp Files =========
      # backup
      backupdir = "$HOME/.vim/backup//,/tmp//,.";
      writebackup = false;
      # swap
      directory = "$HOME/.vim/swap//,/tmp//,.";

      # ================ Indentation ======================
      autoindent = true;
      cindent = true; # automatically indent braces
      smartindent = true;
      smarttab = true;
      shiftwidth = 4;
      softtabstop = 4;
      tabstop = 4;
      expandtab = true;

      # ================ Folds ============================
      foldmethod = "indent"; # fold based on indent
      foldnestmax = 3; # deepest fold is 3 levels
      foldenable = false; # don't fold by default

      # ================ Completion =======================
      wildmode = "list:longest";
      wildmenu = true; # enable ctrl-n and ctrl-p to scroll thru matches

      # stuff to ignore when tab completing
      wildignore = "*.o,*.obj,*~,vim/backups,sass-cache,DS_Store,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif";

      # ================ Scrolling ========================
      scrolloff = 4; # Start scrolling when we're 4 lines away from margins
      sidescrolloff = 15;
      sidescroll = 1;

      # ================ Searching ========================
      incsearch = true;
      hlsearch = true;
      ignorecase = true;
      smartcase = true;

      # ================ Movement ========================
      backspace = "indent,eol,start"; # allow backspace in insert mode
    };

    #
    # ========= UI Plugins =========
    #

    # Display colors for when # FFFFFF codes are detected in buffer text.
    plugins.nvim-colorizer = {
      enable = true;
      fileTypes = [ "*" ];
    };

    # TODO: nixvim: additional commands for alpha
    # Greeter
    plugins.alpha = {
      enable = true;
      theme = "dashboard";
    };

    plugins.lightline = {
      enable = true;
    };
    plugins.bufferline = {
      enable = true;
    };

    plugins.noice = {
      enable = true;
    };

    plugins.treesitter = {
      enable = true;
    };

    # ========= Undo history ========
    # TODO: nixvim: set up    alos, map to <leader>u
    # plugins.undotree = {};


    #
    # ========= File Search =========
    #
    plugins.telescope = {
      # https://github.com/nvim-telescope/telescope.nvim
      enable = true;
      extensions.fzy-native.enable = true;
    };

    # ========= File Nav ===========
    # TODO: nixvim set this one up
    # plugins.harpoon = {};
    plugins.neo-tree.enable = true;
    #
    # ========== Dev Tools =========
    #
    plugins.fugitive.enable = true; # vim-fugitive
    # plugins.surround.enable = true; # vim-surround

    # Load Plugins that aren't provided as modules by nixvim
    extraPlugins = builtins.attrValues {
      inherit (pkgs.vimPlugins)
        vim-illuminate# Highlight similar words as are under the cursor
        vim-numbertoggle# Use relative number on focused buffer only
        range-highlight-nvim# Highlight range as specified in commandline e.g. :10,15
        vimade# Dim unfocused buffers
        vim-twiggy# Fugitive plugin to add branch control
        vimwiki# Vim Wiki
        YouCompleteMe# Code completion engine

        # TODO: nixvim: make sure this is working and not conflicting with YCM
        # supertab # Use <tab> for insert completion needs - https://github.com/ervandew/supertab/

        # Keep vim-devicons as last entry
        vim-devicons;
    };

    # ========= Mapleader =========
    globals.mapleader = ";";

    #
    # ========= Key binds =========
    #
    # MODES Key:
    #    "n" Normal mode
    #    "i" Insert mode
    #    "v" Visual and Select mode
    #    "s" Select mode
    #    "t" Terminal mode
    #    ""  Normal, visual, select and operator-pending mode
    #    "x" Visual mode only, without select
    #    "o" Operator-pending mode
    #    "!" Insert and command-line mode
    #    "l" Insert, command-line and lang-arg mode
    #    "c" Command-line mode
    plugins.which-key.enable = true;

    keymaps = [
      # TODO: nixvim: Test sudo save
      # {
      #   # sudo save
      #   mode= ["c"];
      #   key = "w!!";
      #   action = "<cmd>w !sudo tee > /dev/null %<CR>";
      # }
      {
        mode = [ "" "i" ];
        key = "<c-s>";
        action = "<cmd>w<CR>";
        options = { noremap = true; };

      }
      {
        mode = [ "" "i" ];
        key = "<c-q>";
        action = "<cmd>q!<CR>";
        options = { noremap = true; };

      }
      {
        mode = [ "" "i" ];
        key = "<c-/>";
        action = "<cmd>Telescope live_grep<CR>";
        options = { noremap = true; };
      }
      {
        mode = [ "" "i" ];
        key = "<c-z>";
        action = "<cmd>undo<CR>";
        options = { noremap = true; };
      }
      {
        mode = [ "" "i" ];
        key = "<c-u>";
        action = "<cmd>undo<CR>";
        options = { noremap = true; };
      }

      {
        mode = [ "" "i" ];
        key = "<c-s-z>";
        action = "<cmd>redo<CR>";
        options = { noremap = true; };
      }
      {
        mode = [ "" "i" ];
        key = "<c-r>";
        action = "<cmd>redo<CR>";
        options = { noremap = true; };
      }
      {
        mode = [ "" "i" ];
        key = "<c-y>";
        action = "<cmd>redo<CR>";
        options = { noremap = true; };
      }
      # ======== Movement ========
      {
        # move down through wrapped lines
        mode = [ "n" ];
        key = "j";
        action = "gj";
        options = { noremap = true; };
      }
      {
        # move up through wrapped lines
        mode = [ "n" ];
        key = "k";
        action = "gk";
        options = { noremap = true; };
      }
      {
        # rebind 1/2 page down
        mode = [ "n" ];
        key = "<C-j>";
        action = "<C-d>";
        options = { noremap = true; };
      }
      {
        # rebind 1/2 page up
        mode = [ "n" ];
        key = "<C-k>";
        action = "<C-u>";
        options = { noremap = true; };
      }
      {
        # move to beginning/end of line
        mode = [ "n" ];
        key = "E";
        action = "$";
        options = { noremap = true; };
      }
      # {
      #   # disable default move to beginning/end of line
      #   mode = ["n"];
      #   key = "$";
      #   action = "<nop>";
      # }

      # =========== Fugitive Plugin =========
      {
        # quick git status
        mode = [ "n" ];
        key = "<Leader>gs";
        action = "<cmd>G<CR>";
        options = { noremap = true; };
      }
      {
        # quick merge command: take from right page (tab 3) upstream
        mode = [ "n" ];
        key = "<Leader>gj";
        action = "<cmd>diffget //3<CR>";
        options = { noremap = true; };
      }
      {
        # quick merge command: take from left page (tab 2) head
        mode = [ "n" ];
        key = "<Leader>gf";
        action = "<cmd>diffget //2<CR>";
        options = { noremap = true; };
      }

      # ========== Telescope Plugin =========
      {
        # find files
        mode = [ "n" ];
        key = "<Leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = { noremap = true; };
      }
      {
        # live grep
        mode = [ "n" ];
        key = "<Leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options = { noremap = true; };
      }
      {
        # buffers
        mode = [ "n" ];
        key = "<Leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options = { noremap = true; };
      }
      {
        # help tags
        mode = [ "n" ];
        key = "<Leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options = { noremap = true; };
      }

      # ========= Twiggy =============
      {
        # toggle display twiggy
        mode = [ "n" ];
        key = "<Leader>tw";
        action = ":Twiggy<CR>";
        options = { noremap = true; };
      }
    ];
    extraConfigVim = ''
      " ================ Persistent Undo ==================
      " Keep undo history across sessions, by storing in file.
      " Only works all the time.
      if has('persistent_undo')
          silent !mkdir ~/.vim/backups > /dev/null 2>&1
          set undodir=~/.vim/backups
          set undofile
      endif

      " ================ Vim Wiki config =================
      " See :h vimwiki_list for info on registering wiki paths
      let wiki_0 = {}
      let wiki_0.path = '~/dotfiles.wiki/'
      let wiki_0.index = 'home'
      let wiki_0.syntax = 'markdown'
      let wiki_0.ext = '.md'

      " fill spaces in page names with _ in pathing
      let wiki_0.links_space_char = '_'

      " TODO: nixvim: CONFIRM THESE PATHS FOR NIXOS
      let wiki_1 = {}
      let wiki_1.path = '~/doc/foundry/thefoundry.wiki/'
      let wiki_1.index = 'home'
      let wiki_1.syntax = 'markdown'
      let wiki_1.ext = '.md'
      " fill spaces in page names with _ in pathing
      let wiki_1.links_space_char = '_'

      let g:vimwiki_list = [wiki_0, wiki_1]
      " let g:vimwiki_list = [wiki_0, wiki_1, wiki_2]
    '';

    # extraConfigLua = ''
    # -- ========= Colorscheme Overrides ==========
    # -- Override cursor color and blink for nav and visual mode
    # vim.cmd("highlight Cursor guifg=black guibg=orange");
    #
    # -- Override cursor color for insert mode
    # vim.cmd("highlight iCursor guifg=black guibg=orange");
    # '';
  };
}
