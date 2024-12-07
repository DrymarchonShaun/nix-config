#FIXME: Move attrs that will only work on linux to nixos.nix
#FIXME: if pulling in homemanager for isMinimal maybe set up conditional for some packages
{
  config,
  osConfig,
  inputs,
  lib,
  pkgs,
  hostSpec,
  ...
}:
let
  platform = if hostSpec.isDarwin then "darwin" else "nixos";
in
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home-manager"
    ])
    ./${platform}.nix
    ./zsh
    # ./nixvim
    ./neovim.nix
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    # ./fonts.nix
    ./foot.nix
    ./git.nix
    # ./kitty.nix
    ./screen.nix
    ./ssh.nix
    ./zoxide.nix
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  inherit hostSpec;

  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "macchiato";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault osConfig.system.stateVersion;
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/.src/nix-config";
      SHELL = "zsh";
      TERM = "foot";
      TERMINAL = "foot";
      VISUAL = "nvim";
      EDITOR = "nvim";
      MANPAGER = "batman"; # see ./cli/bat.nix
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

  };
  #TODO:(xdg) maybe move this to its own xdg.nix?
  # xdg packages are pulled in below
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        "XDG_SCREENSHOTS_DIR" = "${config.xdg.userDirs.pictures}/Screenshots";
      };
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = null;
      templates = null;
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here
      btop # resource monitor
      copyq # clipboard manager
      coreutils # basic gnu utils
      # curl
      eza # ls replacement
      dust # disk usage
      fd # tree style ls
      findutils # find
      fzf # fuzzy search
      jq # JSON pretty printer and manipulator
      nix-tree # nix package tree viewer
      inxi # lighter system info than neofetch
      ncdu # TUI disk usage
      pciutils
      pfetch # system info
      pre-commit # git hooks
      peazip # compression & encryption
      ripgrep # better grep
      steam-run # for running non-NixOS-packaged binaries on Nix
      usbutils
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extraction
      xdg-utils # provide cli tools such as `xdg-mime` and `xdg-open`
      xdg-user-dirs
      wev # show wayland events. also handy for detecting keypress codes
      wget # downloader
      zip # zip compression
      ;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
