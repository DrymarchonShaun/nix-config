{
  python3Packages,
  protontricks,
}:

python3Packages.buildPythonApplication rec {
  name = "skyve-launcher";
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
    install -Dm755 ${./skyve-launcher.py} $out/bin/skyve-launcher
  '';
}
