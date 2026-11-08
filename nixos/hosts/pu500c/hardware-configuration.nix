{ ... }:

{
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  boot.loader.grub.devices = [ "/dev/sda" ];
}
