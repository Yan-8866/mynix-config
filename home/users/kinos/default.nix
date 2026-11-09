{ pkgs, ... }:
{
  imports = [
    ../../modules/identity.nix
    ../../modules/programs.nix
    ./emacs-doom/module.nix
  ];

  # standalone home-manager 的 activation 脚本 PATH 是隔离的：只含 coreutils +
  # nix-env 所在目录 + ~/.nix-profile/bin，看不到系统层的 /run/current-system/sw/bin。
  # 所以下面这些必须留在 home profile 里，activation 才能用：
  #   git  -> installDoom 克隆 / doom sync 需要
  #   nix  -> activation 里的 nix-build 健全性检查需要
  #   home-manager -> 保证 switch 之后 CLI 仍留在 profile 里
  # （系统层依旧提供 git/vim/bash，达成"home-manager switch 之前即可用"的目标）
  home.packages = [ pkgs.git pkgs.nix pkgs.home-manager ];
}
