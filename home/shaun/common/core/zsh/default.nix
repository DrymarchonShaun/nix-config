{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.share = true;
    history.path = "$ZDOTDIR/zsh_history";

    plugins = [
      {
        name = "powerlevel10k-config";
        src = ./p10k;
        file = "p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-term-title";
        src = "${pkgs.zsh-term-title}/share/zsh/zsh-term-title/";
      }
      {
        name = "cd-gitroot";
        src = "${pkgs.cd-gitroot}/share/zsh/cd-gitroot";
      }
      {
        name = "zhooks";
        src = "${pkgs.zsh-zhooks}/share/zsh/zhooks";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      # {
      #   name = "zsh-auto-notify";
      #   src = "${pkgs.zsh-auto-notify}/share/zsh/zsh-auto-notify/";
      #   file = "auto-notify.plugin.zsh";
      # }
    ];

    initExtraFirst = ''
       # zmodload zsh/zprof

       export GPG_TTY=$TTY
       ${config.programs.gpg.package}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null

       # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
       # Initialization code that may require console input (password prompts, [y/n]
       # confirmations, etc.) must go above this block; everything else may go below.
       if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
         source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
       fi

       function bgnotify_formatted {
         ## $1=exit_status, $2=command, $3=elapsed_time
        local exit_status=$1
        local cmd="$2"

        # humanly readable elapsed time
        local elapsed="$(( $3 % 60 ))s"
        (( $3 < 60 )) || elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
        (( $3 < 3600 )) || elapsed="$(( $3 / 3600 ))h $elapsed"


        [[ $bgnotify_bell = true ]] && printf '\a' # beep sound
        bgnotify "Hey! \"$cmd\" has just finished" "It completed in $elapsed with exit code $exit_status"
      }
    '';

    initExtra = ''
      # autoSuggestions config

      unsetopt correct # autocorrect commands

      setopt hist_ignore_all_dups # remove older duplicate entries from history
      setopt hist_reduce_blanks # remove superfluous blanks from history items
      setopt inc_append_history # save history entries as soon as they are entered

      # auto complete options
      setopt auto_list # automatically list choices on ambiguous completion
      setopt auto_menu # automatically use menu completion
      zstyle ':completion:*' menu select # select completions with arrow keys
      #zstyle ':completion:*' group-name "" # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

      # nix shell alias

      function ns() {
        local args=()
      for arg in "$@"; do
        args+=("nixpkgs#$arg")
      done
      nix shell "''${args[@]}"
      }

      # zprof
    '';

    oh-my-zsh = {
      enable = true;
      # Standard OMZ plugins pre-installed to $ZSH/plugins/
      # Custom OMZ plugins are added to $ZSH_CUSTOM/plugins/
      # Enabling too many plugins will slowdown shell startup
      plugins = [
        "git"
        "sudo" # press Esc twice to get the previous command prefixed with sudo https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
        "bgnotify"
      ];
      extraConfig = ''
        # Display red dots whilst waiting for completion.
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    shellAliases = {
      # Overrides those provided by OMZ libs, plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #-------------Bat related------------
      cat = "bat";
      diff = "batdiff";
      rg = "batgrep";
      man = "batman";

      #------------Navigation------------
      src = "cd $HOME/.src";
      nfs = "cd $HOME/.src/nix-config";
      l = "eza -lah";
      la = "eza -lah";
      ll = "eza -lh";
      ls = "eza";
      lsa = "eza -lah";

      #-------------Neovim---------------
      e = "nvim";
      vi = "nvim";
      vim = "nvim";

      #-----------Nix related----------------
      # ne = "nix-instantiate --eval";
      # nb = "nix-build";
      # ns = "";

    };
  };
  home.packages = [ pkgs.libnotify ]; # required for bgnotify
}
