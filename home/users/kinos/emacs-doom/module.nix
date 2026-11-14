{ lib, pkgs, ... }:

let
  emacs = pkgs.emacs-unstable-pgtk;
  emacsWithDeps = emacs.pkgs.withPackages (ep: [
    ep.vterm
    ep.pdf-tools
    ep.gt
    # 全量 grammar；由 Emacs wrapper 注入 treesit-extra-load-path
    ep.treesit-grammars.with-all-grammars
  ]);
  doomRepo = "https://github.com/doomemacs/doomemacs";
  doomRev = "v2.2.4";
  git = "${pkgs.git}/bin/git";
in
{
  home.packages = [
    emacsWithDeps
    pkgs.git
    pkgs.ripgrep
    pkgs.fd
    pkgs.pandoc
    pkgs.imagemagick
    pkgs.symbola
  ];

  services.emacs = {
    enable = true;
    package = emacsWithDeps;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };

  # 用户 Doom 配置
  xdg.configFile."doom".source = ./config;

  # org 默认目录
  home.file."org/.keep".text = "";

  # doom 命令进 PATH
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  # 克隆或修复 Doom 核心（固定版本 + 初始化模块子模块）
  home.activation.installDoomCore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOOM_DIR="$HOME/.emacs.d"
    if [ "$(${git} -C "$DOOM_DIR" describe --tags --exact-match 2>/dev/null || true)" != "${doomRev}" ]; then
      rm -rf "$DOOM_DIR"
      ${git} clone --depth 1 --branch ${doomRev} --recurse-submodules ${doomRepo} "$DOOM_DIR"
    fi
    ${git} -C "$DOOM_DIR" submodule update --init --recursive --depth 1
  '';
}
