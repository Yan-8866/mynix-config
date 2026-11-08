{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = import ../../overlays.nix { inputs = inputs; };
}
