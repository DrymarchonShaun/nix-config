[
  # ========== Telescope =========
  {
    mode = [ "n" ];
    key = "<leader>,";
    action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
    options = {
      desc = "Switch Buffer";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>:";
    action = "<cmd>Telescope command_history<cr>";
    options = {
      desc = "Command History";
    };
  }

  # find
  {
    mode = [ "n" ];
    key = "<leader>fb";
    action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
    options = {
      desc = "Buffers";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>fg";
    action = "<cmd>Telescope git_files<cr>";
    options = {
      desc = "Find Files (git-files)";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>fr";
    action = "<cmd>Telescope oldfiles<cr>";
    options = {
      desc = "Recent";
    };
  }
  # git
  {
    mode = [ "n" ];
    key = "<leader>gc";
    action = "<cmd>Telescope git_commits<CR>";
    options = {
      desc = "Commits";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>gs";
    action = "<cmd>Telescope git_status<CR>";
    options = {
      desc = "Status";
    };
  }
  # search
  {
    mode = [ "n" ];
    key = "<leader>s\"";
    action = "<cmd>Telescope registers<cr>";
    options = {
      desc = "Registers";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sa";
    action = "<cmd>Telescope autocommands<cr>";
    options = {
      desc = "Auto Commands";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sb";
    action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
    options = {
      desc = "Buffer";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sc";
    action = "<cmd>Telescope command_history<cr>";
    options = {
      desc = "Command History";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sC";
    action = "<cmd>Telescope commands<cr>";
    options = {
      desc = "Commands";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sd";
    action = "<cmd>Telescope diagnostics bufnr=0<cr>";
    options = {
      desc = "Document Diagnostics";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sD";
    action = "<cmd>Telescope diagnostics<cr>";
    options = {
      desc = "Workspace Diagnostics";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sh";
    action = "<cmd>Telescope help_tags<cr>";
    options = {
      desc = "Help Pages";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sH";
    action = "<cmd>Telescope highlights<cr>";
    options = {
      desc = "Search Highlight Groups";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sk";
    action = "<cmd>Telescope keymaps<cr>";
    options = {
      desc = "Key Maps";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sM";
    action = "<cmd>Telescope man_pages<cr>";
    options = {
      desc = "Man Pages";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sm";
    action = "<cmd>Telescope marks<cr>";
    options = {
      desc = "Jump to Mark";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>so";
    action = "<cmd>Telescope vim_options<cr>";
    options = {
      desc = "Options";
    };
  }
  {
    mode = [ "n" ];
    key = "<leader>sR";
    action = "<cmd>Telescope resume<cr>";
    options = {
      desc = "Resume";
    };
  }
  {
    # find files
    mode = [ "n" ];
    key = "<Leader>ff";
    action = "<cmd>Telescope find_files<CR>";
    options = {
      desc = "Find Files";
      noremap = true;
    };
  }
  {
    # live grep
    mode = [ "n" ];
    key = "<Leader>fg";
    action = "<cmd>Telescope live_grep<CR>";
    options = {
      desc = "Live Grep";
      noremap = true;
    };
  }
  {
    # buffers
    mode = [ "n" ];
    key = "<Leader>fb";
    action = "<cmd>Telescope buffers<CR>";
    options = {
      noremap = true;
    };
  }
  {
    # help tags
    mode = [ "n" ];
    key = "<Leader>fh";
    action = "<cmd>Telescope help_tags<CR>";
    options = {
      noremap = true;
    };
  }
]
