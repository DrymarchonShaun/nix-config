{ python3Packages, fetchPypi, ... }:
python3Packages.buildPythonApplication rec {
  pname = "conventional_pre_commit";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a1ooZzOMWKHRTTAN5otWwXt8hAO7EiFV84Y5pCPSH/E=";
  };

  doCheck = false;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];
}
