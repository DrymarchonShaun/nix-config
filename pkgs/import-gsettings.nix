{
  lib,
  glib,
  writeShellScriptBin,
}:

writeShellScriptBin "import-gsettings" ''
    # usage: import-gsettings
  config="$\{XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
  if [ ! -f "$config" ]; then exit 1; fi

  gnome_schema="org.gnome.desktop.interface"
  gtk_theme="$(grep 'gtk-theme-name' "$config" | cut -d'=' -f2)"
  icon_theme="$(grep 'gtk-icon-theme-name' "$config" | cut -d'=' -f2)"
  cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | cut -d'=' -f2)"
  font_name="$(grep 'gtk-font-name' "$config" | cut -d'=' -f2)"
  prefer_dark="$(grep 'gtk-application-prefer-dark-theme' "$config" | cut -d'=' -f2)"
  ${glib}/bin/gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
  ${glib}/bin/gsettings set "$gnome_schema" icon-theme "$icon_theme"
  ${glib}/bin/gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
  ${glib}/bin/gsettings set "$gnome_schema" font-name "$font_name"
  if [[ $prefer_dark == "1" || $prefer_dark == "true" ]]; then
    ${glib}/bin/gsettings set "$gnome_schema" color-scheme prefer-dark
  fi
''
