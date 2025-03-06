{...}: let
  USE_PIPEWIRE = true; # Pulseaudio is used if false. For RDP.
in {
  services.pulseaudio = {
    enable = !USE_PIPEWIRE; # For RDP audio.
    support32Bit = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = USE_PIPEWIRE;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
