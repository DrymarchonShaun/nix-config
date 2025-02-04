{
  python3Packages,
  protontricks,
}:

python3Packages.buildPythonApplication rec {
  name = "arma3-teamspeak";
  version = "1.0.0";
  pyproject = false;

  dontUnpack = true;

  dependencies = with python3Packages; [
    requests
    vdf
  ];

  buildInputs = [
    protontricks
  ];

  installPhase = ''
    install -Dm755 ${./arma3-teamspeak-launcher.py} $out/bin/arma3-teamspeak-launcher
  '';
}
