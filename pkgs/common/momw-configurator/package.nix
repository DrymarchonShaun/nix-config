{
  buildGoModule,
  fetchFromGitLab,
  musl,
}:
buildGoModule rec {
  pname = "momw-configurator";
  version = "1.18";

  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "momw-configurator";
    rev = "1.18";
    hash = "sha256-kOtm0QnCXDllXxJfUxCgbtnsF4wmooDvT4ilSM/a35Q=";
  };

  vendorHash = "sha256-Pu16/2qZvAkLVb1D3uQt3XrcfBn9lBGY5UVjAGsLKag=";

  ldflags = [
    "-s -w -X 'gitlab.com/modding-openmw/momw-configurator/cfg.Version=${version}'"
    "-linkmode=external"
  ];

  nativeBuildInputs = [ musl ];

}
