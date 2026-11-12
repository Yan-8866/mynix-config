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

    root.hashedPassword = "!";
  };
}
