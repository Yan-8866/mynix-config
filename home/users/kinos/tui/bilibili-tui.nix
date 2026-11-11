{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  home.packages = [ pkgs.bilibili-tui ];
}
