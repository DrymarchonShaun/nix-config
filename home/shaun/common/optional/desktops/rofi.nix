{ lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      # modi = "run,drun";
      modes = "run,drun,display:${pkgs.rofi-randr}/bin/rofi-randr";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "foot";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
    theme =
      let
        inherit (lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg-col = mkLiteral "#24273a";
          bg-col-light = mkLiteral "#24273a";
          border-col = mkLiteral "#24273a";
          selected-col = mkLiteral "#24273a";
          blue = mkLiteral "#8aadf4";
          fg-col = mkLiteral "#cad3f5";
          fg-col2 = mkLiteral "#ed8796";
          grey = mkLiteral "#6e738d";
          width = 600;
          font = "JetBrainsMono Nerd Font 14";
        };

        "element-text, element-icon , mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "window" = {
          height = 360;
          border = 3;
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };

        "inputbar" = {
          children = map mkLiteral [ "prompt" "entry" ];
          background-color = mkLiteral "@bg-col";
          border-radius = 5;
          padding = 2;
        };

        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = 6;
          text-color = mkLiteral "@bg-col";
          border-radius = 3;
          margin = mkLiteral "20 px 0 px 0 px 20 px";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = mkLiteral "\" =\"";
        };

        "entry" = {
          padding = 6;
          margin = mkLiteral "20 px 0 px 0 px 10 px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };

        "listview" = {
          border = mkLiteral "0 px 0 px 0 px";
          padding = mkLiteral "6 px 0 px 0 px";
          margin = mkLiteral "10 px 0 px 0 px 20 px";
          columns = 2;
          lines = 5;
          "background-color" = mkLiteral "@bg-col";
        };

        "element" = {
          padding = 5;
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
        };

        "element-icon" = {
          size = 25;
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col2";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = 10;
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };
        "message" = {
          background-color = mkLiteral "@bg-col-light";
          margin = 2;
          padding = 2;
          border-radius = 5;
        };

        "textbox" = {
          padding = 6;
          margin = mkLiteral "20 px 0 px 0 px 20 px";
          text-color = mkLiteral "@blue";
          background-color = mkLiteral "@bg-col-light";
        };
      };
  };
  xdg.desktopEntries = {
    shutdown = {
      categories = [ "System" ];
      comment = "Shutdown";
      exec = "shutdown now";
      icon = "system-shutdown";
      name = "Shutdown";
      startupNotify = true;
      terminal = false;
      type = "Application";
    };
    reboot = {
      categories = [ "System" ];
      comment = "Reboot";
      exec = "reboot";
      icon = "system-reboot";
      name = "Reboot";
      startupNotify = true;
      terminal = false;
      type = "Application";
    };
  };
}
