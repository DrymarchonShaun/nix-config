{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "zsh-manpage-completion-generator";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "umlx5h";
    repo = "zsh-manpage-completion-generator";
    rev = "v1.0.2";
    hash = "sha256-0CtUafPFt0OxnwdtMSxm/1jcYmDyacj9OoSvfJchixE=";
  };

  vendorHash = "sha256-Wb00v363VjrRKMRQ2beA1pxRYB7LY9yTHPdiXIDdLQA=";

  meta = {
    description = "Automatically generate zsh completions from man page using fish shell completion files.";
    homepage = "https://github.com/umlx5h/zsh-manpage-completion-generator";
    license = "MIT";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.DrymarchonShaun ];
  };
}
