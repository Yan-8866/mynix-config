{ config, ... }:

{
  sops.secrets."github-token" = { };

  sops.templates."gh-hosts.yml".content = ''
    github.com:
        user: Yan-8866
        oauth_token: ${config.sops.placeholder."github-token"}
  '';

  # git 身份与 gh credential helper 都由 HM 声明式生成
  programs.git = {
    enable = true;
    settings.user = {
      name = "kinos";
      email = "kinos@users.noreply.github.com";
    };
  };
  programs.gh.enable = true;

  # 模板在 store 外，用 symlink 让 gh 读取
  xdg.configFile."gh/hosts.yml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."gh-hosts.yml".path;
}
