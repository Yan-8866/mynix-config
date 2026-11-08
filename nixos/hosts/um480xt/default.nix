{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
    ./base
    ./desktop
    ./accounts.nix
  ];
}
