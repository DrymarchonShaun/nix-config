{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
}:
stdenv.mkDerivation {
  pname = "zsh-auto-notify";
  version = "0-unstable-2024-07-08";
  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = "zsh-auto-notify";
    rev = "27c07dddb42f05b199319a9b66473c8de7935856";
    hash = "sha256-ScBwky33leI8mFMpAz3Ng2Z0Gbou4EWMOAhkcMZAWIc=";
  };
  strictDeps = true;
  dontBuild = true;
  buildInputs = [ libnotify ];
  installPhase = ''
    install -Dm755 auto-notify.plugin.zsh --target-directory $out/share/zsh/zsh-auto-notify/
  '';
  meta = {
    homepage = "https://github.com/mollifier/cd-gitroot";
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; linux ++ darwin;
    longDescription = ''
      zsh plugin to send a notification when long-running commands exit.
          You can add the following to your `programs.zsh.plugins` list:
          ```nix
          programs.zsh.plugins = [
            {
              name = "zsh-auto-notify";
              src = "''${pkgs.zsh-auto-notify}/share/zsh/zsh-auto-notify/";
            }
          ];
          ```
    '';
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
  };
}
