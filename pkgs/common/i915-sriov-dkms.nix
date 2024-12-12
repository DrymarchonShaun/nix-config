{
  stdenv,
  kernel,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "i915-sriov-dkms-${kernel.modDirVersion}";

  passthru.moduleName = "i915-sriov-dkms";

  src = fetchFromGitHub {
    owner = "bbaa-bbaa";
    repo = "i915-sriov-dkms";
    rev = "f963850d706247e66b38ae62681680ed9d2c8d07";
    sha256 = "sha256-ONDZkydOo/br058EGuQAB1StsPUvSVSSG9/eIIIeOC4=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
  '';

  installPhase = ''
    install -D i915.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/i915/i915.ko
  '';
}
