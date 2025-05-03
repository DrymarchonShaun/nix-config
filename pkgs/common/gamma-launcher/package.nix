# Primarily taken from https://github.com/bndlfm/dot.nix/blob/14654181b11210e5464e1787cc73786dc0c2c804/pkgs/gamma-launcher.nix
{
  python3Packages,
  lib,
  fetchPypi,
  fetchFromGitHub,
  makeWrapper,
  unrar,
  py7zr,
}:
let
  unrar' = python3Packages.buildPythonPackage rec {
    pname = "unrar";
    version = "0.4";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-skRHpbkwJL5gDvglVmi6I6MPRRF2V3tpFVnqE1n30WQ=";
    };

    propagatedBuildInputs = with python3Packages; [ setuptools-scm ]; # No Python deps

    doCheck = false;
  };

in
python3Packages.buildPythonPackage rec {
  pname = "gamma-launcher";
  version = "2.3-unstable-2025-4-19";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    rev = "cfd4912418ef4e8da1be0a539fca4c1342fe414d";
    hash = "sha256-S0AK7BKz2LsDj4uBePgIRAXvcERpCe1fbdQn1LSmdkg=";
  };

  nativeBuildInputs = [
    makeWrapper
    unrar
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    cloudscraper
    GitPython
    platformdirs
    py7zr
    unrar'
    unrar
    requests
    tenacity
    tqdm
    setuptools
  ];

  postInstall = ''
    wrapProgram $out/bin/gamma-launcher \
      --set UNRAR_LIB_PATH "${unrar}/lib/libunrar.so"
  '';

  meta = with lib; {
    description = "Python cli to download S.T.A.L.K.E.R. GAMMA";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bndlfm ];
  };
}
