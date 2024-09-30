{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  xz,
}:

let
  kernelDirectory = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "i915-sriov-dkms";
  version = "2024.08.09";

  src = fetchFromGitHub {
    owner = "strongtz";
    repo = "i915-sriov-dkms";
    rev = "master";
    hash = "";
  };

  makeFlags = kernel.makeFlags ++ [ "KDIR=${kernelDirectory}" ];

  nativeBuildInputs = [ xz ] ++ kernel.moduleBuildDependencies;

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd) \
      KERNELRELEASE=${kernel.modDirVersion}
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    ${xz}/bin/xz -z -f i915.ko
    cp i915.ko.xz $out/lib/modules/${kernel.modDirVersion}/extra/i915-sriov.ko.xz
  '';

  meta = with lib; {
    description = "Custom module for i915 SRIOV support";
    homepage = "https://github.com/strongtz/i915-sriov-dkms";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
