{ config, ... }:

{
  sops.secrets."github-token" = { };

  sops.templates."gh-hosts.yml".content = ''
    github.com:
        user: Yan-8866
        oauth_token: ${config.sops.placeholder."github-token"}
  '';

  # gh 的 credential helper 依赖 git 模块生成 config
  programs.git.enable = true;
  programs.gh.enable = true;

  # 模板在 store 外，用 symlink 让 gh 读取
  xdg.configFile."gh/hosts.yml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."gh-hosts.yml".path;
}
