{ clangStdenv
, lib
, curl
, substituteAll
, fetchFromGitHub
, fetchurl
, cmake
, curlpp
, doctest
, spdlog
, fmt
, trompeloeil
, nlohmann_json
, qt5
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
  nativeBuildInputs = [ cmake curl.dev ];

  buildInputs = [
    qt5.qtbase
    qt5.qtsvg
  ];

  cmakeFlags = [ "-Wno-dev" ];
  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      argparse_src = fetchFromGitHub {
        owner = "p-ranav";
        repo = "argparse";
        rev = "45664c4";
        sha256 = "sha256-qLD9zD6hbItDn6ZHHWBXrAWhySvqcs40xA5+C/5Fkhw=";
      };
      curlpp_src = curlpp.src.overrideAttrs { version = "master"; rev = "master"; };
      doctest_src = doctest.src;
      fmt_src = fmt.src.overrideAttrs { version = "8.1.1"; rev = "8.1.1"; };
      nlohmann_json_src = nlohmann_json.overrideAttrs { dontBuild = true; version = "3.7.3"; };
      pugixml_src = fetchFromGitHub {
        owner = "muttleyxd";
        repo = "pugixml";
        rev = "simple-build-for-a3ul";
        sha256 = "sha256-FpREdz6DbhnLDGOuQY9rU17SSd6ngA4WfO0kGHqGJPM=";
      };
      spdlog_src = spdlog.src.overrideAttrs { version = "v1.x"; rev = "v1.x"; };
      steamworkssdk_src = fetchurl { url = "https://github.com/julianxhokaxhiu/SteamworksSDKCI/releases/download/1.53/SteamworksSDK-v1.53.0_x64.zip"; sha256 = "sha256-6PQGaPsaxBg/MHVWw2ynYW6LaNSrE9Rd9Q9ZLKFGPFA="; };
      trompeloeil_src = trompeloeil.src.overrideAttrs { version = "64fd171"; rev = "64fd171"; };
    })
  ];
  dontWrapQtApps = true;
  installPhase = ''
    mkdir -p $out/{bin,share}
    mv share $out/
    install -Dm755 bin/$pname "$out/bin/$pname" 
  '';
}
