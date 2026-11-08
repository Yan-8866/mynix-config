{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  machines = (import ../inventory.nix).machines;
in
{
  systems = lib.unique (lib.mapAttrsToList (_: machine: machine.system) machines);

  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt;
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nixfmt
        pkgs.sops
        pkgs.age
        pkgs.ssh-to-age
      ];
    };
  };
}
