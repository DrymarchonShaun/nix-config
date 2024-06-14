{ clangStdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, git
, cmake
, pkg-config
, curlpp
, spdlog
, fmt
, pugixml
, nlohmann_json
, qtbase
, qtsvg
}:
clangStdenv.mkDerivation {
  pname = "arma3-unix-launcher";
  version = "git";
  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = "arma3-unix-launcher";
    rev = "commit-383";
    hash = "sha256-1CXWwujLgNfofTmKkFqaCUGwQTE7QIfhulOwHfhsTy0=";
  };
  nativeBuildInputs = [ wrapQtAppsHook cmake pkg-config ];

  buildInputs = [
    curlpp
    (spdlog.overrideAttrs { version = "1.11.0"; })
    fmt
    nlohmann_json
    pugixml
    qtbase
    qtsvg
  ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    mv share $out/
    install -Dm755 bin/$pname "$out/bin/$pname" 
  '';
}
