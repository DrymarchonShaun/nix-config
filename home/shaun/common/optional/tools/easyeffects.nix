{ ... }:
{
  # TODO(audio): setup eq directly in pipewire and remove easyeffects
  services.easyeffects = {
    enable = true;
  };
}
