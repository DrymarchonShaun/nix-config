{ pkgs, ... }:
let
  discord-wayland = pkgs.discord.overrideAttrs (
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
}
