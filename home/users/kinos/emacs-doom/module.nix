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

  # 用户 Doom 配置（init.el/config.el/packages.el）
  xdg.configFile."doom".source = ./config;

  # doom 命令进 PATH（bin 在 ~/.emacs.d/bin，非 ~/.config/emacs/bin）
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  # 首次自动克隆 doom 核心；之后每次 switch 安装声明的新包并刷新 autoloads
  home.activation.installDoom = ''
    if [ ! -x "$HOME/.emacs.d/bin/doom" ]; then
      git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"
    fi
    "$HOME/.emacs.d/bin/doom" sync
  '';
}
