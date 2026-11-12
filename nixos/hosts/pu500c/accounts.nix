{ ... }:
{
  users.mutableUsers = false;

  users.users = {
    kinos = {
      isNormalUser = true;
      uid = 1000;
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
      hashedPassword = "$y$j9T$pFvm9WRCU8aDkSNedHLeI/$g6VYXTj5pZfAwPHCddFghEt.lznnGMkaIyUiwIUcrjC";
    };

    jun = {
      isNormalUser = true;
      uid = 1001;
      description = "jun";
      home = "/home/jun";
      extraGroups = [
        "networkmanager"
        "video"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhkqy59JE3S2aD2cCrXi9fml49QBIe8OGr7oTPn4eve jun@pu500c"
      ];
      hashedPassword = "$y$j9T$23U/mIfvEhWK30z6Zkb.i.$7aVAcjHhuP0bebqIxPJUQh.H9wgujXyqq3M/6k5ZND8";
    };

    root.hashedPassword = "!";
  };
}
