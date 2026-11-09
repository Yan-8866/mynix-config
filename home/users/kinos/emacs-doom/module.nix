{ pkgs, ... }:

let
  emacs = pkgs.emacs-pgtk;
  emacsWithDeps = emacs.pkgs.withPackages (ep: [ ep.vterm ep.pdf-tools ]);
in
{
  home.packages = [
    emacsWithDeps
    pkgs.git
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

  # 用户 Doom 配置
  xdg.configFile."doom".source = ./config;

  # doom 命令进 PATH
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  # 克隆 Doom 核心
  home.activation.installDoomCore = ''
    if [ ! -x "$HOME/.emacs.d/bin/doom" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"
    fi
  '';
}
