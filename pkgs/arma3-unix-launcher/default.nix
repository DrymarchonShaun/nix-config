{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
}:
stdenv.mkDerivation {
  pname = "arma3-unix-launcher";
  version = "git";
  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = "arma3-unix-launcher";
    rev = "commit-383";
    hash = "sha256-1CXWwujLgNfofTmKkFqaCUGwQTE7QIfhulOwHfhsTy0=";
  };

  nativeBuildInputs = [ cmake ];
}
