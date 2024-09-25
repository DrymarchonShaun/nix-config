#TODO Break this out into smaller files similar to https://github.com/shard77/nix-config-personal/tree/14e94914cada6f388b050771b40dce4b6eefd49a/temp/home-manager/utils/nixvim

# Some fantastic inspiration for this config
# https://seniormars.com/posts/neovim-workflow/

{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    enableMan = true; # install man pages for nixvim options

    clipboard.register = "unnamedplus"; # use system clipboard instead of internal registers

    colorschemes = {
      gruvbox = {
        enable = true;
        settings = {
          contrastDark = true;
          transparentBg = true;
        };
      };
    };

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
      laststatus = 0; # Display status line always
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
      guifont = "NotoSansMono:h9"; # fontname:fontsize

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

      # ================ Splits ============================
      splitbelow = true;
      splitright = true;

      # ================ Completion =======================
      wildmode = "list:longest,list:full"; # for tab completion in : command mode
      wildmenu = true; # enable ctrl-n and ctrl-p to scroll thru matches
      # stuff to ignore when tab completing
      wildignore = "*.o,*.obj,*~,vim/backups,sass-cache,DS_Store,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif";

      # ================ Scrolling ========================
      scrolloff = 4; # Start scrolling when we're 4 lines away from margins
      sidescrolloff = 15;
      sidescroll = 1;

      # ================ Search and Replace ========================
      incsearch = true; # searches incrementally as you type instead of after 'enter'
      hlsearch = true; # highlight search results
      ignorecase = true; # search case insensitive
      smartcase = true; # search matters if capital letter
      inccommand = "split"; # preview incremental substitutions in a split

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

    # Greeter
    # TODO: nixvim: better layout and additional buttons/commands
    plugins.alpha = {
      enable = true;
      iconsEnabled = true; # installs nvim-web-devicons.
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          opts = {
            position = "center";
          };
          val = [
            ""
            "       ooooooo"
            "     oo        oo"
            "   oo            oo"
            "  o                o"
            " o                  o"
            "o                    o"
            "o         ##         o"
            "o         ##         o"
            "o                    o"
            " o                  o"
            "  o                o"
            "   oo            oo"
            "     oo        oo"
            "        oooooo"
            ""
          ];
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  New file";
              on_press.raw = "function() vim.cmd[[ene]] end";
              opts = {
                shortcut = "<Leader>cn";
                position = "center";
              };
            }
            {
              type = "button";
              val = "  Quit Neovim";
              on_press.raw = "function() vim.cmd[[qa]] end";
              opts = {
                shortcut = ":q";
                position = "center";
              };
            }
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = "The way out is through.";
          opts = {
            hl = "Keyword";
            position = "center";
          };
        }
      ];
    };
    # TODO: nixvim: switch to lightline and lightline-bufferline
    plugins.airline = {
      enable = true;
      settings = {
        powerline_fonts = true;
        # TODO: nixvim: Figure out tabline extension stuff in nixvim
        # TODO: nixvim: Possibly use bufferline or lightline-bufferline instead
        # """" Tabline settings
        #
        # " show buffer numbers in the tab line for easier deleting
        # " use :echo airline#extensions#tabline#get() to see what is actually set
        # let g:airline#extensions#tabline#show_tab_nr = 1
        # let g:airline#extensions#tabline#tabs_label = 't'
        # let g:airline#extensions#tabline#buffers_label = 'b'
        # let g:airline#extensions#tabline#buffer_nr_show = 1
        #
        # " Disable showing buffer numbers for splits when using tabs. This gets quite
        # " annoying if there's quite a few splits open.
        # let g:airline#extensions#tabline#show_splits = 0
        #
        # " Title adjustments
        # "airline_symbols Show tab numbers in the tab title
        # let g:airline#extensions#tabline#tab_nr_type = 1
        #
        # " https://github.com/vim-airline/vim-airline/issues/476
        #
        # " show the buffer index
        # "let g:airline#extensions#tabline#buffer_idx_mode = 1
        # "
        # " https://github.com/vim-airline/vim-airline/wiki/Configuration-Examples-and-Snippets#a-different-example-add-the-window-number-in-front-of-the-mode
        # function! WindowNumber(...)
        #     let builder = a:1
        #     let context = a:2
        #     call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
        #     return 0
        # endfunction
      };
    };
    plugins.bufferline = {
      enable = false;
      separatorStyle = "slant"; # “slant”, “padded_slant”, “slope”, “padded_slope”, “thick”, “thin”
      offsets = [
        {
          filetype = "neo-tree";
          text = "Neo-tree";
          highlight = "Directory";
          text_align = "left";
        }
      ];
    };
    #FIXME move these to binds area and decide what to keep
    #    keymaps = [
    #      {
    #        mode = "n";
    #        key = "<Tab>";
    #        action = "<cmd>BufferLineCycleNext<cr>";
    #        options = {
    #          desc = "Cycle to next buffer";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<S-Tab>";
    #        action = "<cmd>BufferLineCyclePrev<cr>";
    #        options = {
    #          desc = "Cycle to previous buffer";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<S-l>";
    #        action = "<cmd>BufferLineCycleNext<cr>";
    #        options = {
    #          desc = "Cycle to next buffer";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<S-h>";
    #        action = "<cmd>BufferLineCyclePrev<cr>";
    #        options = {
    #          desc = "Cycle to previous buffer";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bd";
    #        action = "<cmd>bdelete<cr>";
    #        options = {
    #          desc = "Delete buffer";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bb";
    #        action = "<cmd>e #<cr>";
    #        options = {
    #          desc = "Switch to Other Buffer";
    #        };
    #      }
    #
    #      # {
    #      #   mode = "n";
    #      #   key = "<leader>`";
    #      #   action = "<cmd>e #<cr>";
    #      #   options = {
    #      #     desc = "Switch to Other Buffer";
    #      #   };
    #      # }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>br";
    #        action = "<cmd>BufferLineCloseRight<cr>";
    #        options = {
    #          desc = "Delete buffers to the right";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bl";
    #        action = "<cmd>BufferLineCloseLeft<cr>";
    #        options = {
    #          desc = "Delete buffers to the left";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bo";
    #        action = "<cmd>BufferLineCloseOthers<cr>";
    #        options = {
    #          desc = "Delete other buffers";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bp";
    #        action = "<cmd>BufferLineTogglePin<cr>";
    #        options = {
    #          desc = "Toggle pin";
    #        };
    #      }
    #
    #      {
    #        mode = "n";
    #        key = "<leader>bP";
    #        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
    #        options = {
    #          desc = "Delete non-pinned buffers";
    #        };
    #      }
    #    ];
    #  };
    # TODO none of the lightline stuff seems to work
    #    plugins.lightline = {
    #        enable = true;
    #        settings = {
    #            #List of supported colorschemes can be found at
    #            #https://github.com/itchyny/lightline.vim/blob/master/colorscheme.md.
    #            colorscheme = "default";
    #            component_function = {
    #              gitbranch = "FugitiveHead";
    #            };
    #            component = {
    #              mode = ''%{lightline#mode()}'';
    #              absolutepath = "%F";
    #              relativepath = "%f";
    #              filename = "%t";
    #              modified = "%M";
    #              bufnum = "%n";
    #              paste = ''%{&paste?"PASTE"=""}'';
    #              readonly = "%R";
    #              charvalue = "%b";
    #              charvaluehex = "0x%B";
    #              fileencoding = ''%{&fenc!=#" "?&fenc=&enc}'';
    #              fileformat = "%{&ff}";
    #              filetype = ''%{&ft!=#""?&ft="no ft"}'';
    #              percent = "%3p%%";
    #              percentwin = "%P";
    #              spell = ''%{&spell?&spelllang=" "}'';
    #              lineinfo = "%3l:%-2v%<";
    #              line = "%l";
    #              column = "%c";
    #              close = "%999X X ";
    #              winnr = ''%{winnr()}'';
    #            };
    #            active = {
    #              left = [
    #                  ["mode" "paste"]
    #                ["readonly" "filename" "modified"]
    #              ];
    #              right = [
    #                [ "lineinfo" ]
    #                [ "percent" ]
    #                [
    #                  "fileformat"
    #                  "fileencoding"
    #                  "filetype"
    #                  "charvaluehex"
    #                ]
    #              ];
    #            };
    #            inactive = {
    #                left = [
    #                    [ "filename" ]
    #                ];
    #                right = [
    #                    [ "lineinfo" ]
    #                    [ "percent" ]
    #                ];
    #            };
    #            tabline = {
    #                left = [
    #                    [ "tabs" ]
    #                ];
    #                right = [
    #                    [ "close" ]
    #                ];
    #            };
    #            tab = {
    #                active = [
    #                "tabnum"
    #               "filename"
    #                "modified"
    #                ];
    #                inactive = [
    #                    "tabnum"
    #                    "filename"
    #                    "modified"
    #                ];
    #            };
    #            mode_map = {
    #              "n" = "NORMAL";
    #              "i" = "INSERT";
    #              "R" = "REPLACE";
    #              "v" = "VISUAL";
    #              "V" = "V-LINE";
    #              "<C-v>" = "V-BLOCK";
    #              "c" = "COMMAND";
    #              "s" = "SELECT";
    #              "S" = "S-LINE";
    #              "<C-s>" = "S-BLOCK";
    #              "t" = "TERMINAL";
    #            };
    #        };
    #    };

    # LSP progress indicator
    plugins.fidget = {
      enable = true;
    };

    # fuzzy finder for Ex commands (:), search history (/), and command history (?)
    plugins.wilder = {
      enable = true;
      modes = [
        ":"
        "/"
        "?"
      ]; # enable in all modes
      pipeline = [
        ''
          wilder.branch(wilder.python_file_finder_pipeline({
              file_command = function(_, arg)
                  if string.find(arg, ".") ~= nil then
                      return {"fd", "-tf", "-H"}
                  else
                      return {"fd", "-tf"}
                  end
              end,
              dir_command = {"fd", "-td"},
              filters = {"fuzzy_filter", "difflib_sorter"}
          }), wilder.cmdline_pipeline(), wilder.python_search_pipeline())
        ''
      ];
      renderer = ''
        wilder.popupmenu_renderer({
            highlighter = wilder.basic_highlighter(),
            left = {" "},
            right = {" ", wilder.popupmenu_scrollbar({thumb_char = " "})},
            highlights = {default = "WilderMenu", accent = "WilderAccent"}
        })
      '';
    };

    #
    # ========= Autosave ========
    #
    plugins.auto-session = {
      enable = true;
      logLevel = "error";
      autoSave.enabled = true;
      autoRestore.enabled = false;
      autoSession = {
        suppressDirs = [
          "~/"
          "~/Downloads"
          "~/doc"
          "~/tmp"
        ];
        useGitBranch = true; # include git branch name in session name to differentiate btwn sessions for different branches
      };
    };

    #
    # ========= LSP ========
    #
    plugins.lsp = {
      enable = true;
      # inlayHints = true;

      servers = {
        nixd = {
          enable = true;

          settings = {
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };
            formatting = {
              command = [ "nixfmt" ];
            };
            options = {
              nixos = {
                expr = ''
                  let configs = (builtins.getFlake ("git+file://" + builtins.toString ./.)).nixosConfigurations; in (builtins.head (builtins.attrValues configs)).options
                '';
              };
              home_manager = {
                expr = ''
                  let configs = (builtins.getFlake ("git+file://" + builtins.toString ./.)).homeConfigurations; in (builtins.head (builtins.attrValues configs)).options
                '';
              };
              darwin = {
                expr = ''
                  let configs = (builtins.getFlake ("git+file://" + builtins.toString ./.)).darwinConfigurations; in (builtins.head (builtins.attrValues configs)).options
                '';
              };
            };
          };
        };
      };
    };

    #
    # ========= Undo history ========
    #
    plugins.undotree.enable = true;
    # see Undo and Redo key binds for UndotreeToggle bind

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

    #
    # ========== Dev Tools =========
    #
    plugins.fugitive.enable = true; # vim-fugitive
    # plugins.surround.enable = true; # vim-surround

    # Load Plugins that aren't provided as modules by nixvim
    extraPlugins = builtins.attrValues {
      inherit (pkgs.vimPlugins)
        # linting and fixing (config in extraConfigVim below)
        #   https://github.com/dense-analysis/ale
        #   TODO: nixvim: revamp setup to lua
        #   there is also a lightline-ale  plugin/extension for lightline when you get around to it
        #   by default ALE completion is disabled. need to determine if it's worth enabling and ditching youcompleteme ... it likely is for simplicity!
        ale

        vim-illuminate # Highlight similar words as are under the cursor
        vim-numbertoggle # Use relative number on focused buffer only
        range-highlight-nvim # Highlight range as specified in commandline e.g. :10,15
        vimade # Dim unfocused buffers
        vim-twiggy # Fugitive plugin to add branch control
        vimwiki # Vim Wiki
        YouCompleteMe # Code completion engine

        # TODO: nixvim: make sure this is working and not conflicting with YCM
        # supertab # Use <tab> for insert completion needs - https://github.com/ervandew/supertab/

        # Keep vim-devicons as last entry
        vim-devicons
        ;
    };

    # ========= Mapleader =========
    globals.mapleader = ";";

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
    keymaps = [
      # TODO: nixvim: Test sudo save
      # {
      #   # sudo save
      #   mode= ["c"];
      #   key = "w!!";
      #   action = "<cmd>w !sudo tee > /dev/null %<CR>";
      # }
      {
        mode = [ "n" ];
        key = "<Leader>ve";
        action = "<cmd>e ~/nix-config/home/ta/common/core/nixvim/default.nix<CR>";
        options = {
          desc = "Edit nix-config/home/ta/common/core/nixvim/default.nix";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>vr";
        action = "<cmd>so $MYVIMRC<CR>";
        options = {
          desc = "Reload vimrc";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<space><space>";
        action = "<cmd>nohlsearch<CR>";
        options = {
          desc = "Clear search highlighting";
          noremap = true;
        };
      }

      # ======== Movement ========
      {
        mode = [ "n" ];
        key = "j";
        action = "gj";
        options = {
          desc = "Move down through wrapped lines";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "k";
        action = "gk";
        options = {
          desc = "Move up through wrapped lines";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-j>";
        action = "<C-d>";
        options = {
          desc = "Add bind for 1/2 page down";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-k>";
        action = "<C-u>";
        options = {
          desc = "Add bind for 1/2 page up";
          noremap = true;
        };
      }
      #      {
      #        mode = [ "n" ];
      #        key = "E";
      #        action = "$";
      #        options = {
      #          desc = "Add bind for move to end of line";
      #          noremap = true;
      #        };
      #      }
      # {
      #   # disable default move to beginning/end of line
      #   mode = ["n"];
      #   key = "$";
      #   action = "<nop>";
      # }

      # =========== Editing =========
      {
        mode = [ "n" ];
        key = "<Leader>sr";
        action = ":%s/<C-r><C-w>//g<Left><Left>";
        options = {
          desc = "Substitute the word you are currently on";
          noremap = true;
        };
      }
      # =========== Undo and Redo =========
      {
        mode = [ "n" ];
        key = "<Leader>u";
        action = ":UndotreeToggle<cr>";
        options = {
          desc = "Toggle undotree"; # see undotree plugin
          noremap = true;
        };
      }
      {
        mode = [ "i" ];
        key = ",";
        action = ",<C-g>U";
        options = {
          desc = "Update undo when , operator is used in Insert mode";
          noremap = true;
        };
      }
      {
        mode = [ "i" ];
        key = ".";
        action = ".<C-g>U";
        options = {
          desc = "Update undo when . operator is used in Insert mode";
          noremap = true;
        };
      }
      {
        mode = [ "i" ];
        key = "!";
        action = "!<C-g>U";
        options = {
          desc = "Update undo when ! operator is used in Insert mode";
          noremap = true;
        };
      }
      {
        mode = [ "i" ];
        key = "?";
        action = "?<C-g>U";
        options = {
          desc = "Update undo when ? operator is used in Insert mode";
          noremap = true;
        };
      }
      # =========== Fugitive Plugin =========
      {
        mode = [ "n" ];
        key = "<Leader>gs";
        action = "<cmd>G<CR>";
        options = {
          desc = "quick git status";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>gj";
        action = "<cmd>diffget //3<CR>";
        options = {
          desc = "quick merge command: take from right page (tab 3) upstream";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>gf";
        action = "<cmd>diffget //2<CR>";
        options = {
          desc = "quick merge command: take from left page (tab 2) head";
          noremap = true;
        };
      }

      # ========== Telescope Plugin =========
      {
        mode = [ "n" ];
        key = "<Leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = {
          desc = "find files";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options = {
          desc = "live grep";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options = {
          desc = "buffers";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options = {
          desc = "help tags";
          noremap = true;
        };
      }

      # ========= Twiggy =============
      {
        mode = [ "n" ];
        key = "<Leader>tw";
        action = ":Twiggy<CR>";
        options = {
          desc = "toggle display twiggy";
          noremap = true;
        };
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
           let wiki_0.path = '~/src/dotfiles.wiki/'
           let wiki_0.index = '0_home'
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

           " ================ Ale ========================
      "     let g:ale_linters = {
      "                 \ 'c': ['clang-tidy'],
      "                 \ 'python': ['flake8'],
      "                 \ 'vim': ['vint'],
      "                 \ 'markdown': ['markdownlint'],
      "     \ }

      "     let g:ale_fixers = {
      "           \ 'c': ['clang-format'],
      "           \ 'javascript': ['prettier', 'eslint'],
      "           \ 'json': ['fixjson', 'prettier'],
      "           \ 'python': ['black', 'isort'],

      "           \ }

      "     " Set global fixers for all file types except Markdown
      "     " Why? because double spaces at the end of a line in markdown indicate a
      "     " linebreak without creating a new paragraph
      "     function! SetGlobalFixers()
      "       let g:ale_fixers['*'] = ['trim_whitespace', 'remove_trailing_lines']
      "     endfunction

      "     augroup GlobalFixers
      "       autocmd!
      "       autocmd VimEnter * call SetGlobalFixers()
      "     augroup END

      "     " Set buffer-local fixers for Markdown files
      "     augroup MarkdownFixers
      "       autocmd!
      "       autocmd FileType markdown let b:ale_fixers = ['prettier']
      "     augroup END

      "     let g:ale_fix_on_save = 1
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

# PLUGINS TO LEARN AND INTEGRATE
#
# These are from the amazing article: https://seniormars.com/posts/neovim-workflow/
# vim-grepper
#

# # Syntax support
# vim-polyglot # a collection of language packs for vim
#
# # The following are commented out because they are already included in vim-polyglot
# # but in case poly-glot fails I want to be able to quickly enable what I need.
# haskell-vim
# plantuml-syntax
# pgsql-vim
# python-syntax
# rust-vim
# vim-markdown
# vim-nix
# vim-terraform
# vim-toml
