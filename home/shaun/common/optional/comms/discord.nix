{ pkgs, ... }:
let
  discord-wayland = pkgs.unstable.discord.overrideAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/discord \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    }
  );
in
{
  home.packages = [ (discord-wayland.override { withVencord = true; }) ];
  # home.packages = [ discord-wayland ];
  systemd.user.services.discord = {
    Unit = {
      StartLimitBurst = 30;
      Description =
        "Autostart Discord in Sway";
      Requires = [ "tray.target" ];
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      RestartSec = 5;
      ExecStart = "/bin/sh -c \"${pkgs.coreutils}/bin/sleep 5 && ${discord-wayland}/bin/discord\"";
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
