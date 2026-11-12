{
  pkgs,
  ...
}:
let
  configPath = "/home/kinos/.config/sops-nix/secrets/rendered/mihomo.yaml";
in
{
  # 系统 DNS 优先走 mihomo TUN，DHCP DNS 保留为 fallback
  networking.networkmanager.insertNameservers = [ "198.18.0.2" ];

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = configPath;
  };

  systemd.services.mihomo = {
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
      ExecStartPre = [
        "+${pkgs.bash}/bin/bash -c 'test -f ${configPath}'"
      ];
      BindReadOnlyPaths = [
        "${pkgs.v2ray-rules-dat}/share/v2ray/geoip.dat:/var/lib/private/mihomo/geoip.dat"
        "${pkgs.v2ray-rules-dat}/share/v2ray/geosite.dat:/var/lib/private/mihomo/geosite.dat"
      ];
    };
  };
}
