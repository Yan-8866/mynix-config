{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
    ./desktop
    ./accounts.nix
    ./mihomo.nix
  ];
}
