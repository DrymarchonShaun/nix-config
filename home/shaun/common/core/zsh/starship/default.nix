{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000; # ms
      add_newline = false;
      format = lib.concatStrings [
        # left side
        "$hostname"
        "$directory"
        "$git_state"
        "$git_branch"
        "$git_commit"
        "$git_status"

        "$fill "

        # right side
        "$status"
        "$cmd_duration"
        "$jobs"
        "$direnv"
        "$all"
        "$nix_shell"
        "line_break"
        "$character"
      ];
      line_break = {
        disabled = false;
      };
      fill = {
        symbol = "·";
      };
      aws = {
        format = "[$symbol($profile)(\($region\))(\[$duration\])]($style) ";
        symbol = "  ";
      };
      buf = {
        format = "[$symbol($version)]($style) ";
        style = "bold mauve";
        symbol = " ";
      };
      c = {
        format = "[$symbol($version(-$name))]($style) ";
        style = "bold teal";
        symbol = " ";
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      conda = {
        format = "[$symbol$environment]($style) ";
        style = "bold green";
        symbol = " ";
      };
      crystal = {
        format = "[$symbol($version)]($style) ";
        style = "bold rosewater ";
        symbol = " ";
      };
      dart = {
        format = "[$symbol($version)]($style) ";
        style = "bold sapphire";
        symbol = " ";
      };
      directory = {
        truncation_symbol = "…/";
        before_repo_root_style = "yellow";
        repo_root_style = "bold yellow";
        truncate_to_repo = false;
        read_only = " 󰌾";
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
        style = "bold blue";
        symbol = " ";
      };
      elixir = {
        format = "[$symbol($version \\(OTP $otp_version\\))]($style) ";
        style = "bold mauve";
        symbol = " ";
      };
      elm = {
        format = "[$symbol($version)]($style) ";
        style = "bold blue";
        symbol = " ";
      };
      fennel = {
        format = "[$symbol($version)]($style) ";
        style = "bold green";
        symbol = " ";
      };
      fossil_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold sapphire";
        symbol = " ";
      };
      git_branch = {
        format = "[$symbol$branch([:](text)$remote_branch)]($style) ";
        style = "green";
        symbol = " ";
      };
      git_commit = {
        tag_symbol = "  ";
        style = "green";
        format = "([$symbol$tag]($style))([$hash](yellow)) ";
      };
      git_state = {
        merge = "merge ";
        revert = "revert ";
        rebase = "rebase ";
        cherry_pick = "cherry ";
        bisect = "bisect ";
        am = "am ";
        am_or_rebase = "am/rebase ";
        format = "[$state($progress_current/$progress_total)]($style) ";
        style = "bold red";
      };
      git_status = {
        ahead = "⇡$count ";
        behind = "⇣$count ";
        diverged = "⇣$behind_count ⇡$ahead_count ";
        stashed = "*$count ";
        modified = "!$count ";
        renamed = "➜$count ";
        staged = "+$count ";
        untracked = "?$count ";
        style = "yellow";
        format = lib.concatStrings [
          "[$ahead_behind($stashed)](green)"
          "[($renamed)($staged)($modified)($untracked)]($style)"
        ];
      };
      golang = {
        format = "[$symbol($version)]($style) ";
        style = "bold sky";
        symbol = " ";
      };
      gradle = {
        format = "[$symbol($version)]($style) ";
        style = "bold teal";
        symbol = " ";
      };
      guix_shell = {
        format = "[$symbol]($style) ";
        style = "bold green";
        symbol = " ";
      };
      haskell = {
        format = "[$symbol($version)]($style) ";
        style = "bold pink";
        symbol = " ";
      };
      haxe = {
        format = "[$symbol($version)]($style) ";
        style = "bold peach";
        symbol = " ";
      };
      hg_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold sky";
        symbol = " ";
      };
      hostname = {
        format = "[($ssh_symbol)$hostname]($style) ";
        style = "blue";
        ssh_only = false;
        ssh_symbol = " ";
      };
      java = {
        format = "[$symbol($version)]($style) ";
        style = "bold subtext0";
        symbol = " ";
      };
      julia = {
        format = "[$symbol($version)]($style) ";
        style = "bold red dimmed";
        symbol = " ";
      };
      kotlin = {
        format = "[$symbol($version)]($style) ";
        style = "bold mauve dimmed";
        symbol = " ";
      };
      lua = {
        format = "[$symbol($version)]($style) ";
        style = "bold blue dimmed";
        symbol = " ";
      };
      memory_usage = {
        format = "\$symbol[$ram( | $swap)]($style) ";
        style = "bold text dimmed";
        symbol = "󰍛 ";
      };
      meson = {
        format = "[$symbol$project]($style) ";
        style = "bold mauve";
        symbol = "󰔷 ";
      };
      nim = {
        format = "[$symbol($version)]($style) ";
        style = "bold yellow dimmed";
        symbol = "󰆥 ";
      };
      nix_shell = {
        format = "[$symbol$state(\\($name\\))]($style) ";
        style = "bold blue";
        symbol = " ";
        impure_msg = "";
        pure_msg = "pure ";
      };
      nodejs = {
        format = "[$symbol($version)]($style) ";
        style = "bold green dimmed";
        symbol = " ";
      };
      ocaml = {
        format = "[$symbol($version)(\($switch_indicator$switch_name\))]($style) ";
        style = "bold peach dimmed";
        symbol = " ";
      };
      os = {
        symbols = {
          AlmaLinux = " ";
          Alpaquita = " ";
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          RedHatEnterprise = " ";
          Redhat = " ";
          Redox = "󰀘 ";
          RockyLinux = " ";
          SUSE = " ";
          Solus = "󰠳 ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
          openSUSE = " ";
        };
      };
      package = {
        format = "[$symbol$version]($style) ";
        style = "bold text";
        symbol = "󰏗 ";
      };
      perl = {
        format = "[$symbol($version)]($style) ";
        style = "bold sky dimmed";
        symbol = " ";
      };
      php = {
        format = "[$symbol($version)]($style) ";
        style = "bold overlay0";
        symbol = " ";
      };
      pijul_channel = {
        format = "[$symbol$channel]($style) ";
        style = "bold text";
        symbol = " ";
      };
      python = {
        format = "[\${symbol}\${pyenv_prefix}(\${version})(\($virtualenv\))]($style) ";
        style = "bold yellow";
        symbol = " ";
      };
      rlang = {
        style = "bold subtext2";
        symbol = "󰟔 ";
      };
      ruby = {
        format = "[$symbol($version)]($style) ";
        style = "bold maroon";
        symbol = " ";
      };
      rust = {
        format = "[$symbol($version)]($style) ";
        style = "bold red";
        symbol = "󱘗 ";
      };
      scala = {
        format = "[$symbol($version)]($style) ";
        style = "bold red dimmed";
        symbol = " ";
      };
      spack = {
        format = "[$symbol$environment]($style) ";
        style = "bold blue dimmed";
      };
      swift = {
        format = "[$symbol($version)]($style) ";
        style = "bold maroon dimmed";
        symbol = " ";
      };
      zig = {
        format = "[$symbol($version)]($style) ";
        style = "bold peach dimmed";
        symbol = " ";
      };

    };
  };
}
