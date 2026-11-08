{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  machines = (import ../inventory.nix).machines;
  homeNixpkgs = import ./nixpkgs.nix { inputs = inputs; };

  mkHome =
    host: machine: user:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = machine.system;
        config = homeNixpkgs.config;
        overlays = homeNixpkgs.overlays;
      };
      extraSpecialArgs = {
        inputs = inputs;
        hostName = host;
        userName = user;
        isNixos = machine.nixos or true;
      };
      modules = [
        ./users/${user}
      ]
      ++ lib.optional (builtins.pathExists ./users/${user}/${host}.nix) ./users/${user}/${host}.nix
      ++ lib.optional (builtins.pathExists ../secrets/users/${user}.yaml) ./modules/sops.nix;
    };
in
{
  flake.homeConfigurations = lib.concatMapAttrs (
    host: machine:
    lib.listToAttrs (
      map (user: lib.nameValuePair "${user}@${host}" (mkHome host machine user)) machine.users
    )
  ) machines;
}
