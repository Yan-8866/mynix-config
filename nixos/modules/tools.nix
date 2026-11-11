{ pkgs, ... }:

{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = [
    pkgs.git
    pkgs.vim
  ];
}
