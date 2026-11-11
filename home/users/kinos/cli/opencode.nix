{ config, pkgs, ... }:

{
  sops.secrets."deepseek-api-key" = { };

  programs.opencode = {
    enable = true;

    # 内置全透明主题
    tui.theme = "lucent-orng";

    settings = {
      # 密钥由 sops 解密，不入 store
      provider.deepseek.options.apiKey = "{file:${config.sops.secrets."deepseek-api-key".path}}";
      model = "deepseek/deepseek-flash";

      # mcp-nixos
      mcp.nixos = {
        type = "local";
        command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
        enabled = true;
      };

      # 默认不加载 mcp-nixos 工具
      tools."nixos_*" = false;

      # 改 NixOS/home-manager 配置时用 Tab 切到它，可查包与选项
      agent.nix = {
        description = "维护本仓库的 NixOS/home-manager 配置，可查 nixpkgs 包与选项";
        mode = "primary";
        tools."nixos_*" = true;
      };
    };
  };
}
