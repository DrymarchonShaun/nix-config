# Primarily taken from https://github.com/bndlfm/dot.nix/blob/14654181b11210e5464e1787cc73786dc0c2c804/pkgs/gamma-launcher.nix
{
  python3Packages,
  lib,
  fetchPypi,
  fetchFromGitHub,
  makeWrapper,
  unrar,
}:
let
  inflate64 = python3Packages.buildPythonPackage rec {
    pname = "inflate64";
    version = "0.3.1";
    format = "pyproject";
    src = fetchPypi {
      inherit version pname;
      sha256 = "sha256-tS3Y/v0roXnl36GNbsp+L8giWEYWJxwDnV7x+cqQxxw=";
    };
    buildInputs = with python3Packages; [
      setuptools-scm
    ];
    propagatedBuildInputs = with python3Packages; [
      setuptools
    ];
    doCheck = false;
  };

  multivolumefile = python3Packages.buildPythonPackage rec {
    pname = "multivolumefile";
    version = "0.2.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-oGSNCq+8luWRmNXBfprK1+tTGr6lEDXQjOgGDcrXCdY=";
    };
    propagatedBuildInputs = with python3Packages; [ setuptools-scm ]; # No Python deps
    doCheck = false;
  };

  pybcj = python3Packages.buildPythonPackage rec {
    pname = "pybcj";
    version = "1.0.1";
    src = fetchPypi {
      inherit version pname; # Corrected: inherit 'name' as well
      sha256 = "sha256-i2gu0Iyqv7fAQtS+CD4o3caSr7He/1VnER+IVQcbdcM=";
    };
    propagatedBuildInputs = with python3Packages; [
      setuptools-scm
      toml
    ];
    doCheck = false;
  };

  pyppmd = python3Packages.buildPythonPackage rec {
    pname = "pyppmd";
    version = "1.0.0";
    src = fetchPypi {
      inherit version pname; # Corrected: inherit 'name' as well
      sha256 = "sha256-B1yb0pfjsKh9166ryn/uZoIYrL5p7MHGURBkVY3ohA8=";
    };
    propagatedBuildInputs = with python3Packages; [ setuptools-scm ]; # No Python deps
    doCheck = false;
  };

  pyzstd = python3Packages.buildPythonPackage rec {
    pname = "pyzstd";
    version = "0.15.6";
    src = fetchPypi {
      inherit version pname; # Corrected: inherit 'name' as well
      sha256 = "sha256-MqG2fVNA2N84HnGKeIQXRV7ddr7X6KTL0lms3DC14X4=";
    };
    propagatedBuildInputs = with python3Packages; [ ]; # No Python deps
    doCheck = false;
  };

  py7zr = python3Packages.buildPythonPackage rec {
    # Renamed to avoid shadowing
    pname = "py7zr";
    version = "0.20.4";
    format = "pyproject";
    src = fetchPypi {
      inherit version pname; # Corrected: inherit 'name' as well
      sha256 = "sha256-HQH5jqHh9cSZQDWGkbIHb5pYSAVkJlQeeD3jODT1niE=";
    };
    propagatedBuildInputs = with python3Packages; [
      setuptools # propagatedBuildInputs
      texttable
      pycryptodomex
      brotli
      psutil
      inflate64
      pyzstd
      pyppmd
      pybcj
      multivolumefile
    ];
    doCheck = false;
  };

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
  version = "2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    rev = "v${version}";
    hash = "sha256-wS4qA9+fEx5IneDLZfpQSo8Yiy86gUImtlJXkkt7n4c=";
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
