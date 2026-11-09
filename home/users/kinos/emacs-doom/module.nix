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

  # 用户 Doom 配置
  xdg.configFile."doom".source = ./config;

  # doom 命令进 PATH
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  # 首次自动克隆 doom 核心；之后每次 switch 安装声明的新包并刷新 autoloads
  # 注意：HM 的 activation 阶段在 installPackages 之前跑，此时 emacs 往往还没进
  # ~/.nix-profile/bin（尤其之前 installPackages 因冲突中止、profile 被改坏时）。
  # 所以这里直接把 emacs 派生本身的 /bin 绝对路径塞进 PATH（并设 EMACS），与
  # profile 装没装完彻底解耦；git 走系统层 /run/current-system/sw/bin。
  home.activation.installDoom = ''
    export PATH="${emacsWithDeps}/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
    export EMACS="${emacsWithDeps}/bin/emacs"
    if [ ! -x "$HOME/.emacs.d/bin/doom" ]; then
      git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"
    fi
    "$HOME/.emacs.d/bin/doom" sync
  '';
}
