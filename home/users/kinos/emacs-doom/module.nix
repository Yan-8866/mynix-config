{ pkgs, ... }:

let
  emacs = pkgs.emacs-pgtk;
  emacsWithDeps = emacs.pkgs.withPackages (ep: [ ep.vterm ep.pdf-tools ]);
in
{
  home.packages = [
    emacsWithDeps
    pkgs.ripgrep
    pkgs.fd
    pkgs.imagemagick
    # pkgs.gruvbox-gtk-theme  # 外壳美化：Emacs 的 GTK 对话框主题，先注释看差别
  ];

  services.emacs = {
    enable = true;
    package = emacsWithDeps;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
    # Service.Environment = [ "GTK_THEME=Gruvbox-Dark" ];  # 外壳美化，注释对比
  };

  # 用户 Doom 配置（HM 只负责把这份配置落盘到 ~/.config/doom）
  xdg.configFile."doom".source = ./config;

  # doom 命令进 PATH：克隆 doomemacs 后可直接敲 `doom sync`
  # 注意：首次需自己 `git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d`
  # 以及 `doom sync`；HM 不再自动跑这些。
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];
}
