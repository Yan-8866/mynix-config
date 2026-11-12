{
  config,
  lib,
  ...
}:
{
  sops.secrets.mihomo-subscription-url = { };
  sops.secrets.mihomo-webui-secret = { };

  sops.templates."mihomo.yaml".content =
    lib.replaceStrings
      [ "@subscription-url@" "@webui-secret@" ]
      [ config.sops.placeholder.mihomo-subscription-url config.sops.placeholder.mihomo-webui-secret ]
      (builtins.readFile ./mihomo.yaml);
}
