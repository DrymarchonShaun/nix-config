{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "fir";
  version = "0-unstable-2024-11-20";
  src = fetchFromGitHub {
    owner = "GICodeWarrior";
    repo = "fir";
    rev = "24c3ebda712e96427caec6d4fde49a94b0bb1ad1";
    sha256 = "sha256-uTtdM6WNbtcVL1SUFD0LqnOj+5VDzzzbORnsWQi6MEo=";
  };
  installPhase = ''
    mkdir -p $out/opt/
    cp -r $src $out/opt/fir
  '';
}
