{
  pkgs,
  lib,
  config,
  ...
}:
let
  startInDirectoryScript = pkgs.writeShellScript "exec-terminal-in-directory" ''
    ${config.programs.foot.package}/bin/foot --working-directory "$@"
  '';
in
{
  xdg.configFile."Thunar/uca.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1685763450018352-1</unique-id>
            <command>${startInDirectoryScript} %f</command>
            <description>Open the preferred terminal in the current directory.</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
    </action>
    </actions>
  '';
}
