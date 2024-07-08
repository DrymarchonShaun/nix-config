{ lib, config, ... }: {
  security.polkit.enable = true;

  ## allow users in group "storage" to mount disk
  # https://github.com/coldfix/udiskie/wiki/Permissions
  security.polkit.extraConfig = ''
  '' +
  lib.strings.optionalString
    config.services.udisks2.enable ''
    polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        var permission = {
        "org.freedesktop.udisks.drive-detach": YES,
        "org.freedesktop.udisks.drive-eject": YES,
        "org.freedesktop.udisks.filesystem-mount": YES,
        "org.freedesktop.udisks.luks-unlock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.eject-media-other-seat": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.filesystem-mount-system-internal": YES,
        "org.freedesktop.udisks2.filesystem-unmount-others": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        "org.freedesktop.udisks2.power-off-drive-other-seat": YES
        };
        if (subject.local && subject.active && subject.isInGroup("storage")) {
        return permission[action.id];
        }
    });
  '';
}
