{
  lib,
  python3Packages,
  onlykey-cli,
}:

python3Packages.buildPythonPackage rec {
  pname = "onlykey-python";
  version = onlykey-cli.version;

  src = onlykey-cli.src;

  build-system = onlykey-cli.build-system;

  propagatedBuildInputs = onlykey-cli.propagatedBuildInputs;

  # Requires having the physical onlykey (a usb security key)
  doCheck = false;
  pythonImportsCheck = [ "onlykey.client" ];

  meta = with lib; {
    description = "OnlyKey client and command-line tool";
    mainProgram = "onlykey-python";
    homepage = "https://github.com/trustcrypto/python-onlykey";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
