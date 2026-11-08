{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  machines = (import ../inventory.nix).machines;

  # 造一份 NixOS 配置
  mkSystem =
    name: machine:
    lib.nixosSystem {
      system = machine.system;
      specialArgs = {
        inputs = inputs;
        hostName = name;
      };
      modules = [
        ./modules
        ./hosts/${name}
      ]
      ++ lib.optional (builtins.pathExists ../secrets/hosts/${name}.yaml) ./modules/sops.nix;
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs mkSystem (
    lib.filterAttrs (_: machine: machine.nixos or true) machines
  );
}
