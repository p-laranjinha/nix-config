{...}: {
  specialisation = {
    use-sunshine.configuration = {
      system.nixos.tags = ["use-sunshine"];
      personal.remote-access.sunshine = true;
    };
  };
}
