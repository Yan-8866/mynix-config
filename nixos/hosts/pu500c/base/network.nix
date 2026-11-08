{ ... }:

{
  networking.networkmanager.enable = true;
  networking.nameservers = [ "223.5.5.5" "119.29.29.29" ];
  networking.networkmanager.dns = "none";
}
