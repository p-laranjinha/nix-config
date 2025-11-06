{...}: {
  specialisation = {
    use-sunshine.configuration = {
      system.nixos.tags = ["use-sunshine"];
      personal.remote-access.sunshine = true;
      personal.displays.one-1920x1080-screen = true;
    };
  };
}
