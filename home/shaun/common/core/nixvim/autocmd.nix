[

  # cd to directory as telescope live_grep will only use the working directory of the shell that launched neovim in the first place
  {
    event = [ "VimEnter" ];
    pattern = [ "*" ];
    command = "execute 'cd ' .. expand('%:p:h')";
  }

  # Highlight on Yank
  {
    event = [ "TextYankPost" ];
    callback.__raw = ''
      function() 
        vim.highlight.on_yank()
      end'';
  }
  # Close certain filetypes with <q>
  {
    event = [ "FileType" ];
    pattern = [
      "PlenaryTestPopup"
      "help"
      "lspinfo"
      "notify"
      "qf"
      "query"
      "spectre_panel"
      "startuptime"
      "tsplayground"
      "neotest-output"
      "checkhealth"
      "neotest-summary"
      "neotest-output-panel"
    ];
    callback.__raw = ''
      function (event)
        vim.bo
        [ event.buf ].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
      end'';
  }
  {
    event = "FileType";
    pattern = [ "gitcommit" "markdown" ];
    callback.__raw = ''
      function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
      end'';
  }
  # Auto create dir when saving a file, in case some intermediate directory does not exist
  {
    event = [ "BufWritePre" ];
    callback.__raw = ''
      function(args)
        if args.match:match "^%w%w+://" then return end
        vim.fn.mkdir(vim.fn.fnamemodify(vim.loop.fs_realpath(args.match) or args.match, ":p:h"), "p")
        end
    '';
  }
]
