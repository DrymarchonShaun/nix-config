{
  stdenv,
  fetchzip,
  dpkg,
  libtool,
  cups,
  popt,
  libtiff,
  libpng,
  ghostscript,
}:
let
  version = "3.30";
in
stdenv.mkDerivation {
  pname = "cnijfilter-mx340";
  inherit version;
  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/1/0100002721/01/cnijfilter-mx340series-${version}-1-i386-deb.tar.gz";
    sha256 = "sha256-0H0UrXVUzx2aK9msvOh7jY5paPcs+CJagDYxHxbblCU=";
  };
  nativeBuildInputs = [ dpkg ];

  buildInputs = [
    libtool
    cups
    popt
    libtiff
    libpng
    ghostscript
  ];
  unpackPhase = ''
    dpkg -x $src/packages/cnijfilter-mx340series_${version}-1_i386.deb debcontent
    dpkg -x $src/packages/cnijfilter-common_${version}-1_i386.deb debcontent
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model;
  '';

  postInstall = ''
      # bin
      install -c -m 755 debcontent/usr/bin/* $out/bin/;

      # lib
    mkdir -p $out/lib/bjlib;
    install -c -m 755 debcontent/usr/lib/bjlib/* $out/lib/bjlib;
    install -c -s -m 755 debcontent/usr/lib/*.so.* $out/lib;

    pushd $out/lib;
    for so_file in *.so.*; do
      ln -s $so_file ''${so_file/.so.*/}.so;
      patchelf --set-rpath $out/lib $so_file;
    done;
    popd;

    # share
    cp -r debcontent/usr/share/ $out;
  '';
  dontPatchELF = true;

  # fortify hardening makes the filter crash
  # https://github.com/NixOS/nixpkgs/issues/276125
  hardeningDisable = [ "fortify3" ];

}
