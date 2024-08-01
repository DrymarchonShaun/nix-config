{ ... }: {
  python = {
    path = ./python-playground;
    description = "Python template, using poetry2nix";
    welcomeText = ''
      # Getting started
      - Run `direnv allow`
      - Run `poetry run python -m sample_package`
    '';
  };
}
