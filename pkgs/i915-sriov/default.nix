{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "i915-sriov-dkms-${version}-${kernel.version}";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "strongtz";
    repo = "i915-sriov-dkms";
    rev = "52020b4f469f9bd40c48e296e9a3e826a11df177";
    sha256 = "sha256-YwPf8G1v4cVy/EEG3iMKe2wXIYrJY+l+7YZ95kE7T1s=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
  '';

  installPhase = ''
    install -D i915.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/i915/i915.ko
  '';

  meta = {
    description = "A kernel module to enable SRIOV on new Intel GPUs";
    homepage = "https://github.com/strongtz/i915-sriov-dkms";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.nyadiia ];
    platforms = lib.platforms.linux;
  };
}
