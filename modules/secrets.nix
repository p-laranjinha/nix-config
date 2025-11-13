{
  inputs,
  lib,
  this,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    (lib.mkAliasOptionModule ["secrets"] ["sops" "secrets"])
  ];

  # sops = {
  #   secrets = with lib; let
  #     secretsDir = "${inputs.self}/secrets";
  #   in
  #     mapAttrs' (name: _: let
  #       parts = splitString "." name;
  #       base = head parts;
  #       format =
  #         if length parts > 1
  #         then elemAt parts 1
  #         else "binary";
  #     in
  #       nameValuePair base {
  #         sopsFile = "${secretsDir}/${name}";
  #         inherit format;
  #         key = this.hostname;
  #       }) (builtins.readDir secretsDir);
  # };
}
