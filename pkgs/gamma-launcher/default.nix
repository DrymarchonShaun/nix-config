{ python3Packages
, dev
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "v1.7-unstable-2024-07-02";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Mord3rca";
    rev = "90d74777d849ef292bf6811374fdb4fa09361138";
    hash = "sha256-Ye6VEtCt5Fe5gfo+8eSA+LHawQuWR1XbZt6wBFAC/3c=";
  };

  build-system = [
    python3Packages.setuptools
  ];
  doCheck = false;
  dependencies = [
    dev.python3Packages.py7zr
    python3Packages.beautifulsoup4
    python3Packages.platformdirs
    python3Packages.rarfile
    python3Packages.requests
    python3Packages.tenacity
    python3Packages.tqdm
    python3Packages.python-magic
  ];
}
