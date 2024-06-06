[
  # ======== Movement ========

  # better up/down

  {
    mode = [ "n" "x" ];
    key = "j";
    action = "v:count == 0 ? 'gj' : 'j'";
    options = { expr = true; silent = true; };
  }
  #  {
  #    mode = [ "n" "x" ];
  #    key = "<Down>";
  #    action = "v:count == 0 ? 'gj' : 'j'";
  #    options = {
  #      expr = true;
  #      silent = true;
  #    };
  #  }
  {
    mode = [ "n" "x" ];
    key = "k";
    action = "v:count == 0 ? 'gk' : 'k'";
    options = {
      expr = true;
      silent = true;
    };
  }
  #  {
  #    mode = [ "n" "x" ];
  #    key = "<Up>";
  #    action = "v:count == 0 ? 'gk' : 'k'";
  #    options = {
  #      expr = true;
  #      silent = true;
  #    };
  #  }
  # Move to window using the <ctrl> hjkl keys
  {
    mode = [ "n" ];
    key = "<C-h>";
    action = "<C-w>h";
    options = {
      desc = "Go to Left Window";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<C-j>";
    action = "<C-w>j";
    options = {
      desc = "Go to Lower Window";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<C-k>";
    action = "<C-w>k";
    options = {
      desc = "Go to Upper Window";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<C-l>";
    action = "<C-w>l";
    options = { desc = "Go to Right Window"; remap = true; };
  }

  # Resize window using <ctrl> arrow keys
  {
    mode = [ "n" ];
    key = "<C-Up>";
    action = "<cmd>resize +2<cr>";
    options = { desc = "Increase Window Height"; };
  }
  {
    mode = [ "n" ];
    key = "<C-Down>";
    action = "<cmd>resize -2<cr>";
    options = { desc = "Decrease Window Height"; };
  }
  {
    mode = [ "n" ];
    key = "<C-Left>";
    action = "<cmd>vertical resize +2<cr>";
    options = { desc = "Decrease Window Width"; };
  }
  {
    mode = [ "n" ];
    key = "<C-Right>";
    action = "<cmd>vertical resize -2<cr>";
    options = { desc = "Increase Window Width"; };
  }

  # Move Lines
  {
    mode = [ "n" ];
    key = "<A-j>";
    action = "<cmd>m .+1<cr>==";
    options = { desc = "Move Down"; };
  }
  {
    mode = [ "n" ];
    key = "<A-k>";
    action = "<cmd>m .-2<cr>==";
    options = { desc = "Move Up"; };
  }
  {
    mode = [ "i" ];
    key = "<A-j>";
    action = "<esc><cmd>m .+1<cr>==gi";
    options = { desc = "Move Down"; };
  }
  {
    mode = [ "i" ];
    key = "<A-k>";
    action = "<esc><cmd>m .-2<cr>==gi";
    options = { desc = "Move Up"; };
  }
  {
    mode = [ "v" ];
    key = "<A-j>";
    action = ":m '>+1<cr>gv=gv";
    options = { desc = "Move Down"; };
  }
  {
    mode = [ "v" ];
    key = "<A-k>";
    action = ":m '<-2<cr>gv=gv";
    options = { desc = "Move Up"; };
  }
  #
  # ======== Buffers ==========
  #  
  {
    mode = [ "n" ];
    key = "<leader>bp";
    action = "<Cmd>BufferLineTogglePin<CR>";
    options = { desc = "Toggle Pin"; };
  }
  {
    mode = [ "n" ];
    key = "<leader>bP";
    action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
    options = { desc = "Delete Non-Pinned Buffers"; };
  }
  {
    mode = [ "n" ];
    key = "<leader>bo";
    action = "<Cmd>BufferLineCloseOthers<CR>";
    options = { desc = "Delete Other Buffers"; };
  }
  {
    mode = [ "n" ];
    key = "<leader>br";
    action = "<Cmd>BufferLineCloseRight<CR>";
    options = { desc = "Delete Buffers to the Right"; };
  }
  {
    mode = [ "n" ];
    key = "<leader>bl";
    action = "<Cmd>BufferLineCloseLeft<CR>";
    options = { desc = "Delete Buffers to the Left"; };
  }
  {
    mode = [ "n" ];
    key = "<S-h>";
    action = "<cmd>BufferLineCyclePrev<cr>";
    options = { desc = "Prev Buffer"; };
  }
  {
    mode = [ "n" ];
    key = "<S-l>";
    action = "<cmd>BufferLineCycleNext<cr>";
    options = { desc = "Next Buffer"; };
  }
  {
    mode = [ "n" ];
    key = "[b";
    action = "<cmd>BufferLineCyclePrev<cr>";
    options = { desc = "Prev Buffer"; };
  }
  {
    mode = [ "n" ];
    key = "]b";
    action = "<cmd>BufferLineCycleNext<cr>";
    options = { desc = "Next Buffer"; };
  }
  {
    key = "<leader>bb";
    action = "<cmd>e #<cr>";
    options = { desc = "Switch to Other Buffer"; };
  }
  {
    mode = [ "n" ];
    key = "<leader>`";
    action = "<cmd>e #<cr>";
    options = { desc = "Switch to Other Buffer"; };
  }

  {
    mode = [ "n" ];
    key = "<leader>be";
    action.__raw = ''function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
          end'';
    options = { desc = "Buffer Explorer"; };
  }

  # Clear search with <esc>
  {
    mode = [ "i" "n" ];
    key = "<esc>";
    action = "<cmd>noh<cr><esc>";
    options = { desc = "Escape and Clear hlsearch"; };
  }
  # Clear search, diff update and redraw
  # taken from runtime/lua/_editor.lua
  {
    mode = [ "n" ];
    key = "<leader>ur";
    action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
    options = { desc = "Redraw / Clear hlsearch / Diff Update"; };
  }

  # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  {
    mode = [ "n" ];
    key = "n";
    action = "'Nn'[v:searchforward].'zv'";
    options = { expr = true; desc = "Next Search Result"; };
  }
  {
    mode = [ "x" ];
    key = "n";
    action = "'Nn'[v:searchforward]";
    options = { expr = true; desc = "Next Search Result"; };
  }
  {
    mode = [ "o" ];
    key = "n";
    action = "'Nn'[v:searchforward]";
    options = { expr = true; desc = "Next Search Result"; };
  }
  {
    mode = [ "n" ];
    key = "N";
    action = "'nN'[v:searchforward].'zv'";
    options = { expr = true; desc = "Prev Search Result"; };
  }
  {
    mode = [ "x" ];
    key = "N";
    action = "'nN'[v:searchforward]";
    options = { expr = true; desc = "Prev Search Result"; };
  }
  {
    mode = [ "o" ];
    key = "N";
    action = "'nN'[v:searchforward]";
    options = { expr = true; desc = "Prev Search Result"; };
  }

  # Add undo break-points
  {
    mode = [ "i" ];
    key = ",";
    action = ",<c-g>u";
  }
  {
    mode = [ "i" ];
    key = ".";
    action = ".<c-g>u";
  }
  {
    mode = [ "i" ];
    key = ";";
    action = ";<c-g>u";
  }

  #
  # ======== Terminal =========
  #
  {
    mode = [ "t" ];
    key = "<esc><esc>";
    action = "<c-\\><c-n>";
    options = {
      desc = "Enter Normal Mode";
    };
  }
  {
    mode = [ "t" ];
    key = "<C-h>";
    action = "<cmd>wincmd h<cr>";
    options = {
      desc = "Go to Left Window";
    };
  }
  {
    mode = [ "t" ];
    key = "<C-j>";
    action = "<cmd>wincmd j<cr>";
    options = {
      desc = "Go to Lower Window";
    };
  }
  {
    mode = [ "t" ];
    key = "<C-k>";
    action = "<cmd>wincmd k<cr>";
    options = {
      desc = "Go to Upper Window";
    };
  }
  {
    mode = [ "t" ];
    key = "<C-l>";
    action = "<cmd>wincmd l<cr>";
    options = {
      desc = "Go to Right Window";
    };
  }
  {
    mode = [ "t" ];
    key = "<C-/>";
    action = "<cmd>close<cr>";
    options = {
      desc = "Hide Terminal";
    };
  }
  {
    mode = [ "t" ];
    key = "<c-_>";
    action = "<cmd>close<cr>";
    options = {
      desc = "which_key_ignore";
    };
  }

  # ======== Windows ========
  {
    mode = [ "n" ];
    key = "<leader>ww";
    action = "<C-W>p";
    options = {
      desc = "Other Window";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>wd";
    action = "<C-W>c";
    options = {
      desc = "Delete Window";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>w-";
    action = "<C-W>s";
    options = {
      desc = "Split Window Below";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>w|";
    action = "<C-W>v";
    options = {
      desc = "Split Window Right";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>-";
    action = "<C-W>s";
    options = {
      desc = "Split Window Below";
      remap = true;
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>|";
    action = "<C-W>v";
    options = {
      desc = "Split Window Right";
      remap = true;
    };
  }

  #
  # ======== Tabs =========
  #

  {
    mode = [ "n" ];
    key = "<leader><tab>l";
    action = "<cmd>tablast<cr>";
    options = {
      desc = "Last Tab";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader><tab>f";
    action = "<cmd>tabfirst<cr>";
    options =
      {
        desc = "First Tab";
      };
  }
  {
    mode = [ "n" ];
    key = "<leader><tab><tab>";
    action = "<cmd>tabnew<cr>";
    options = {
      desc = "New Tab";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader><tab>]";
    action = "<cmd>tabnext<cr>";
    options = {
      desc = "Next Tab";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader><tab>d";
    action = "<cmd>tabclose<cr>";
    options = {
      desc = "Close Tab";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader><tab>[";
    action = "<cmd>tabprevious<cr>";
    options = {
      desc = "Previous Tab";
    };
  }
]
