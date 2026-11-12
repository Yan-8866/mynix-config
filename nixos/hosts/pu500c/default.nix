{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
    ./accounts.nix
    ./desktop
    ./mihomo.nix
  ];
}
