{
  version',
  src',
  python311Packages,
}:
python311Packages.buildPythonPackage {
  pname = "millennium-core-utils";
  version = version';

  src = src' + /sdk;

  pyproject = true;
  build-system = [ python311Packages.setuptools ];

  sourceRoot = "sdk/python-packages/core-utils";

  patches = [
    ./paths.patch
  ];
  postUnpack = ''
    cp $src/package.json $sourceRoot/package.json
    cp $src/README.md $sourceRoot/README.md
  '';
}
