{...}: let
  USE_PIPEWIRE = true; # Pulseaudio is used if false. For RDP.
in {
  services.pulseaudio = {
    enable = !USE_PIPEWIRE;
    support32Bit = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = USE_PIPEWIRE;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
