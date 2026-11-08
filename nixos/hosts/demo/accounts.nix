{ config, ... }:
{
  users.mutableUsers = false;

  sops.secrets."demo-password".neededForUsers = true;
  sops.secrets."root-password".neededForUsers = true;

  users.users = {
    demo = {
      isNormalUser = true;
      description = "demo";
      home = "/home/demo";
      extraGroups = [
        "networkmanager"
        "video"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets."demo-password".path;
    };

    root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
