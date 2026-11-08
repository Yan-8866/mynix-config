{ ... }:
{
  imports = [
    ./network.nix
    ./openssh.nix
    ./nix.nix
    ./locale.nix
    ./journald.nix
    ./zram.nix
    ./fonts.nix
  ];
}
