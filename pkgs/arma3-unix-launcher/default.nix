{ stdenv
, cmake
, curl
, curlpp
, doctest
, fetchFromGitHub
, fetchurl
, fmt
, nlohmann_json
, qt5
, spdlog
, substituteAll
, trompeloeil
, wrapQtAppsHook
}:
stdenv.mkDerivation {
  pname = "arma3-unix-launcher";
  version = "git";
  src = fetchFromGitHub {
    owner = "DrymarchonShaun";
    repo = "arma3-unix-launcher";
    rev = "rfdlc";
    hash = "sha256-w47V8gVXIkapfEAhXFDQaKYHbx2wIk2uIh53OQUxmPU=";
  };
  nativeBuildInputs = [ wrapQtAppsHook cmake spdlog curlpp.src curl ];

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
      curlpp_src = curlpp.src;
      doctest_src = doctest;
      fmt_src = fmt;
      nlohmann_json_src = nlohmann_json;
      pugixml_src = fetchFromGitHub {
        owner = "muttleyxd";
        repo = "pugixml";
        rev = "simple-build-for-a3ul";
        sha256 = "sha256-FpREdz6DbhnLDGOuQY9rU17SSd6ngA4WfO0kGHqGJPM=";
      };
      spdlog_src = spdlog;
      steamworkssdk_src = fetchurl { url = "https://github.com/julianxhokaxhiu/SteamworksSDKCI/releases/download/1.53/SteamworksSDK-v1.53.0_x64.zip"; sha256 = "sha256-6PQGaPsaxBg/MHVWw2ynYW6LaNSrE9Rd9Q9ZLKFGPFA="; };
      trompeloeil_src = trompeloeil;
    })
  ];
}
