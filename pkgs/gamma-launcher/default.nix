{ stdenv
, fetchurl
, autoPatchelfHook
, zlib
,
}:
stdenv.mkDerivation rec {
  pname = "gamma-launcher";
  version = "v1.7";

  src = fetchurl {
    url = "https://github.com/Mord3rca/${pname}/releases/download/${version}/gamma-launcher";
    sha256 = "sha256-lWP9HxInkx78VTm5lZ+DMwrAlrLQYIUslrNcDSaKtpY=";
    executable = true;
  };

  buildInputs = [
    autoPatchelfHook
    zlib
  ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/gamma-launcher
  '';
}

# { python3Packages
# , fetchFromGitHub
# }:
#  python3Packages.buildPythonApplication rec {
#     pname = "gamma-launcher";
#     version = "v1.7";
# 
#     src = fetchFromGitHub {
#       repo = pname;
#       owner = "Mord3rca";
#       rev = version;
#       hash = "sha256-WRuqmoR2LM8niuLzCTXSS6DEGANBje/yVuEKMLYcwDc=";
#     };
# 
#   build-system = with python3Packages; [
#     setuptools
#   ];
#   doCheck = false;
#   dependencies = with python3Packages; [
#     py7zr
#     beautifulsoup4
#     platformdirs
#     rarfile
#     requests
#     tenacity
#     tqdm
#     python-magic
#   ];
# }
