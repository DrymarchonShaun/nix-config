{
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication {
  name = "steam-launch-options-merger";
  version = "1.0.0";
  pyproject = false;

  dontUnpack = true;

  dependencies = with python3Packages; [
    vdf
  ];

  installPhase = ''
    install -Dm755 ${./steam-launch-options-merger.py} $out/bin/steam-launch-options-merger
  '';
}
