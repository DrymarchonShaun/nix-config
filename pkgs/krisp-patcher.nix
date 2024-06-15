{ writers
, python3Packages
}:
writers.writePython3Bin "krisp-patcher"
{
  libraries = with python3Packages; [ capstone pyelftools ];
  flakeIgnore = [
    "E501" # line too long (82 > 79 characters)
    "F403" # ‘from module import *’ used; unable to detect undefined names
    "F405" # name may be undefined, or defined from star imports: module
  ];
}
  (builtins.readFile (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/sersorrel/sys/main/hm/discord/krisp-patcher.py";
    sha256 = "sha256-87VlZKw6QoXgQwEgxT3XeFY8gGoTDWIopGLOEdXkkjE=";
  }))
