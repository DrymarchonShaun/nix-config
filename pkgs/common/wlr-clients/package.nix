{
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  libdrm,
  libxkbcommon,
  wayland,
  libpng,
  libGL,
  mesa,
  cairo,
  ffmpeg,
}:
stdenv.mkDerivation {
  name = "wlr-clients-0.1.0";

  mesonBuildType = "release";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlr-clients";
    rev = "1f3b0ec09aa91bec9de0e744a353f387982f22cf";
    sha256 = "sha256-qBQi7muzF0w2NGh1Fs/fLIUd8kwKTsV2RaITr8ywcBU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland-protocols
    libdrm
    libxkbcommon
    wayland.dev
    libpng.dev
    libGL.dev
    mesa.dev
    cairo.dev
    ffmpeg.dev
  ];

  installPhase = ''
    rm -r *.*
    rm -r -- */
    mkdir -p $out/bin
    cp * $out/bin/
  '';
}
