{
  pkgs,
  lib,
  config,
  ...
}:
{
  home-manager.users.${config.hostSpec.username}.xfconf.settings = {
    thunar = {
      "last-icon-view-zoom-level" = "THUNAR_ZOOM_LEVEL_100_PERCENT";
      "last-details-view-zoom-level" = "THUNAR_ZOOM_LEVEL_50_PERCENT";
      "last-details-view-visible-columns" = lib.concatStringsSep "," [
        "THUNAR_COLUMN_NAME"
        "THUNAR_COLUMN_PERMISSIONS"
        "THUNAR_COLUMN_OWNER"
        "THUNAR_COLUMN_GROUP"
        "THUNAR_COLUMN_SIZE"
        "THUNAR_COLUMN_DATE_MODIFIED"
        "THUNAR_COLUMN_MIME_TYPE"
      ];
      "last-sort-column" = "THUNAR_COLUMN_NAME";
      "last-sort-order" = "GTK_SORT_ASCENDING";
      "last-details-view-column-order" = lib.concatStringsSep "," [
        "THUNAR_COLUMN_NAME"
        "THUNAR_COLUMN_PERMISSIONS"
        "THUNAR_COLUMN_OWNER"
        "THUNAR_COLUMN_GROUP"
        "THUNAR_COLUMN_SIZE"
        "THUNAR_COLUMN_DATE_MODIFIED"
        "THUNAR_COLUMN_MIME_TYPE"
        "THUNAR_COLUMN_DATE_ACCESSED"
        "THUNAR_COLUMN_DATE_CREATED"
        "THUNAR_COLUMN_DATE_DELETED"
        "THUNAR_COLUMN_LOCATION"
        "THUNAR_COLUMN_RECENCY"
        "THUNAR_COLUMN_SIZE_IN_BYTES"
        "THUNAR_COLUMN_TYPE"
      ];
      "last-details-view-fixed-columns" = false;
      "last-show-hidden" = false;
      "misc-directory-specific-settings" = true;
      "misc-folder-item-count" = "THUNAR_FOLDER_ITEM_COUNT_ONLY_LOCAL";
      # "misc-show-delete-action" = true;
    };
  };
  programs = {
    thunar = {
      enable = true;
      plugins = builtins.attrValues {
        inherit (pkgs.xfce)
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
          ;
      };
    };
    xfconf.enable = true; # required to persist Thunar settings since we're not running on XFCE
    file-roller.enable = true; # required for Thunar archive plugin
  };
  services = {
    gvfs.enable = true; # for stuff like Trash folders etc
    udisks2.enable = true; # storage device manipulation
    tumbler.enable = true; # thumbnail generation service for Thunar
  };
}
