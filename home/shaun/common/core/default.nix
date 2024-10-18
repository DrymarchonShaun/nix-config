{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [

    # Theme
    inputs.catppuccin.homeManagerModules.catppuccin

    # nix-index database
    inputs.nix-index-database.hmModules.nix-index

    # Packages with custom configs go here

    ./bash.nix # backup shell
    ./bat.nix # cat with better syntax highlighting and extras like batgrep.
    ./direnv.nix # shell environment manager. Hooks inot shell direnv to look for .envrc before prompts
    ./fonts.nix # core fonts
    ./fzf.nix # fuzzy-finder for shell
    ./git.nix # personal git config
    ./gnupg.nix
    ./foot.nix # terminal
    ./neovim.nix # vim goodness
    ./screen.nix # hopefully rarely needed but good to have if so
    ./ssh.nix # personal ssh configs
    ./sops.nix
    ./zoxide.nix # cd replacement
    ./zsh # primary shell: includes zsh, oh-my-zsh, and p10k theme

    # TODO: Not set, need to investigate but will need custom config if used:
    # ./shellcolor.nix

  ] ++ (builtins.attrValues outputs.homeManagerModules);

  # services.ssh-agent.enable = true;

  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "macchiato";
  };

  home = {
    username = lib.mkDefault "shaun";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "$HOME/.src/nix-config";
      SHELL = "${pkgs.zsh}/bin/zsh";
      TERM = "foot";
      TERMINAL = "foot";
      EDITOR = "nvim";
      MANPAGER = "batman"; # see ./cli/bat.nix
    };
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here

      # TODO: spaces before comment are removed by nixpkgs-fmt
      # See: https://github.com/nix-community/nixpkgs-fmt/issues/305
      #borgbackup # backups
      btop # resource monitor
      coreutils # basic gnu utils
      # curl
      killall # better kill
      eza # ls replacement
      fd # tree style ls
      findutils # find
      fzf # fuzzy search
      jq # JSON pretty printer and manipulator
      nix-tree # nix package tree viewer
      ncdu # TUI disk usage
      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption
      ripgrep # better grep
      steam-run # for running non-NixOS-packaged binaries on Nix
      usbutils
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extraction
      wget # downloader
      zip # zip compression
      ;
  };

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      inputs.catppuccin-vsc.overlays.default
    ] ++ builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
