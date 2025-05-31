{
  rustPlatform,
  fetchFromGitHub,

}:
rustPlatform.buildRustPackage rec {
  pname = "sqf-analyzer-lsp";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sqf-analyzer";
    repo = "sqf-analyzer-lsp";
    rev = "${version}";
    hash = "sha256-3/HuR4+qDq4XXmKBNa4nTccbCnkV+ZlHZn/Vj08djUc=";
  };

  cargoHash = "sha256-C7hcMPC3FRoh2AZbAOxewh9JFIgQ/7bd81Rq9iYl5kA=";

}
