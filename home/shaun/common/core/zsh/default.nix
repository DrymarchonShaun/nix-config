{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./starship.nix ];
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

    plugins =
      [
        # {
        #   name = "powerlevel10k-config";
        #   src = ./p10k;
        #   file = "p10k.zsh";
        # }
        # {
        #   name = "zsh-powerlevel10k";
        #   src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        #   file = "powerlevel10k.zsh-theme";
        # }
      ]
      # The iso doesn't use our overlays, so don't add custom packagesa
      #FIXME:move these to an optional custom plugins module and remove iso check
      ++ lib.optionals (config.hostSpec.hostName != "iso") [
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
          src = "${pkgs.zhooks}/share/zsh/zhooks";
        }
      ];

    initExtraFirst = ''
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
      zstyle ':completion:*' group-name "" # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

      #      bindkey '^I' forward-word         # tab
      #      bindkey '^[[Z' backward-word      # shift+tab
      #      bindkey '^ ' autosuggest-accept   # ctrl+space

           # nix shell alias

      function ns() {
        local args=()
      for arg in "$@"; do
        args+=("nixpkgs#$arg")
      done
      nix shell "''${args[@]}"
      }
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
      doc = "cd $HOME/documents";
      scripts = "cd $HOME/scripts";
      ts = "cd $HOME/.talon/user/fidget";
      src = "cd $HOME/.src";
      edu = "cd $HOME/.src/edu";
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
      nfc = "nix flake check";
      ne = "nix instantiate --eval";
      nb = "nix build";
      # ns = "nix shell";

      #-------------Git Goodness-------------
      # just reference `$ alias` and use the defautls, they're good.
    };
  };
  home.packages = [ pkgs.libnotify ]; # required for bgnotify
}
