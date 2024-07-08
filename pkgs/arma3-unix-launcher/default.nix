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
, buildDayZLauncher ? false
,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arma3-unix-launcher";
  version = "383-unstable-2024-07-07";
  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = finalAttrs.pname;
    rev = "ceee0def11a329a5be7dbadb1abb3682a13b6ee1";
    hash = "sha256-qSvPUZi9RnIYReg7LUkpEs0uYChu3zzHJd/tXQafhp0=";
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

  cmakeFlags = [ "-Wno-dev" ] ++ lib.optional buildDayZLauncher [ "-DBUILD_DAYZ_LAUNCHER=ON" ];
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
    ./profiles.patch
  ];

  meta = {
    homepage = "https://github.com/muttleyxd/arma3-unix-launcher/";
    description = "A clean, intuitive Arma 3 + DayZ SA Launcher for GNU/Linux and MacOS";
    license = with lib.licenses; [
      # Launcher
      mit
      # Steamworks SDK
      # unfree
    ];
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    mainProgram = "arma3-unix-launcher";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
