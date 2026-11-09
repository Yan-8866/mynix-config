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
  # 注意：HM 生成的 activation PATH 只含 coreutils + nix 所在目录（解析进 store，
  # 没有 ~/.nix-profile/bin），所以 emacs/git 在 activation 里默认找不到。这里手动
  # 把 home profile 与系统 bin 补到 PATH 前面，doom sync 才能用到 emacs、克隆用到 git。
  home.activation.installDoom = ''
    export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
    if [ ! -x "$HOME/.emacs.d/bin/doom" ]; then
      git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"
    fi
    "$HOME/.emacs.d/bin/doom" sync
  '';
}
