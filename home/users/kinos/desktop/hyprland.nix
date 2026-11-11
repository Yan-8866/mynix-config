{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yazi
    hyprlauncher
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}
