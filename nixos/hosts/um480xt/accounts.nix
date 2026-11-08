{ config, ... }:
{
  users.mutableUsers = false;

  sops.secrets."kinos-password".neededForUsers = true;
  sops.secrets."root-password".neededForUsers = true;

  users.users = {
    kinos = {
      isNormalUser = true;
      description = "kinos";
      home = "/home/kinos";
      extraGroups = [
        "networkmanager"
        "video"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQxtRLAYrqBcbMUVJVlFKBYzt0UDqvh3F9YAbKVgHRG"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGD0KRgkgxMXY2OyiTHs3pOcwZCBCW1RrSIQariGm0xB"
      ];
      hashedPasswordFile = config.sops.secrets."kinos-password".path;
    };

    root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
