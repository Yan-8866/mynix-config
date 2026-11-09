{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.bash
    pkgs.git
    pkgs.vim
  ];
}
