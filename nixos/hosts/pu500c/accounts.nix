{ config, ... }:
{
  users.mutableUsers = false;

  sops.secrets."jun-password".neededForUsers = true;
  sops.secrets."root-password".neededForUsers = true;

  users.users = {
    jun = {
      isNormalUser = true;
      description = "jun";
      home = "/home/jun";
      extraGroups = [
        "networkmanager"
        "video"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhkqy59JE3S2aD2cCrXi9fml49QBIe8OGr7oTPn4eve jun@pu500c"
      ];
      hashedPasswordFile = config.sops.secrets."jun-password".path;
    };

    root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
