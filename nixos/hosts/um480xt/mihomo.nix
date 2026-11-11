{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 系统 DNS 优先走 mihomo TUN，DHCP DNS 保留为 fallback
  networking.networkmanager.insertNameservers = [ "198.18.0.2" ];

  sops.secrets.mihomo-subscription-url = { };
  sops.secrets.mihomo-webui-secret = { };

  sops.templates."mihomo.yaml" = {
    content =
      lib.replaceStrings
        [ "@subscription-url@" "@webui-secret@" ]
        [ config.sops.placeholder.mihomo-subscription-url config.sops.placeholder.mihomo-webui-secret ]
        (builtins.readFile ./mihomo.yaml);
    restartUnits = [ "mihomo.service" ];
  };

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = config.sops.templates."mihomo.yaml".path;
  };

  systemd.services.mihomo.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "5s";
    BindReadOnlyPaths = [
      "${pkgs.v2ray-rules-dat}/share/v2ray/geoip.dat:/var/lib/private/mihomo/geoip.dat"
      "${pkgs.v2ray-rules-dat}/share/v2ray/geosite.dat:/var/lib/private/mihomo/geosite.dat"
    ];
  };
}
