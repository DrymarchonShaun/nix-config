{ lib
, stdenv
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
,
}:
stdenv.mkDerivation rec {
  pname = "arma3-unix-launcher";
  version = "383-unstable-2024-04-18";
  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = pname;
    rev = "793eb6da640334107c906b106a7f300f0dab47ba";
    hash = "sha256-JD/CoCSAqbx77JUkRbRo/ipsWOmr/JFqrFS4SP1AEyw=";
  };
  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    spdlog
    curlpp.src
    curl
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtsvg
  ];

  cmakeFlags = [ "-Wno-dev" ];
  patches = [
    # prevent CMake from trying to get libraries on the internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      argparse_src = fetchFromGitHub {
        owner = "p-ranav";
        repo = "argparse";
        rev = "45664c4e9f05ff287731a9ff8b724d0c89fb6e77";
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
      steamworkssdk_src = fetchurl {
        url = "https://github.com/julianxhokaxhiu/SteamworksSDKCI/releases/download/1.53/SteamworksSDK-v1.53.0_x64.zip";
        sha256 = "sha256-6PQGaPsaxBg/MHVWw2ynYW6LaNSrE9Rd9Q9ZLKFGPFA=";
      };
      trompeloeil_src = trompeloeil;
    })
    # game won't launch with steam integration anyways, disable it
    ./disable_steam_integration.patch
  ];

  meta = {
    homepage = "https://github.com/muttleyxd/arma3-unix-launcher/";
    description = "A clean, intuitive Arma 3 + DayZ SA Launcher for GNU/Linux and MacOS";
    license = with lib.licenses; [
      # Launcher
      mit
      # Steamworks SDK
      unfree
    ];
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    mainProgram = "arma3-unix-launcher";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
