{
  lib,
  pkgs,
  ...
}:

lib.mkIf pkgs.stdenv.isLinux {
  home.packages = [
    pkgs.unstable.tidal-cycles-full
    pkgs.unstable.tidal-cycles-full.passthru.ghcWithTidal
  ];
}
