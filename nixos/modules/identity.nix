{ hostName, lib, ... }:
{
  networking.hostName = hostName;
  system.stateVersion = lib.mkDefault "26.05";
}
