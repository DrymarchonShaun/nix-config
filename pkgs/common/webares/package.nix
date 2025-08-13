{
  replaceVars,
  fetchFromGitHub,
  jdk,
  jre,
  makeWrapper,
  maven,
}:
let
  jdk' = jdk.override {
    enableJavaFX = true;
  };
  jre' = jre.override {
    enableJavaFX = true;
  };
in
maven.buildMavenPackage {
  pname = "webares";
  version = "unstable-2025-06-14";

  src = fetchFromGitHub {
    owner = "kenan-garnier";
    repo = "Webares";
    rev = "bb39eed06353055ffefc9bfce34a9611c4af7bbf";
    hash = "sha256-GsbHN8K4UwdQ/KoOi0q28XEL0EE2U0Q2X5kWkOIUTMs=";
  };

  patches = [
    (replaceVars ./set-webserver-url.patch {
      host = "localhost";
      port = "8785";
    })
  ];

  mvnJdk = jdk';

  mvnHash = "sha256-rb2qGptP5sMHWAFCrMAneF1vRzM9/2UKWnmVy3EB3X0=";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/webares
    install -Dm644 target/Webares-1.0-SNAPSHOT.jar $out/share/webares/webares.jar

    makeWrapper ${jre'}/bin/java $out/bin/webares \
      --add-flags "-jar $out/share/webares/webares.jar"

    runHook postInstall
  '';
}
