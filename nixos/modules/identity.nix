{
  hostName,
  config,
  lib,
  ...
}:
let
  inventory = import ../../inventory.nix;
  users = inventory.machines.${hostName}.users or [ ];
in
{
  assertions = [
    {
      assertion = builtins.all (user: builtins.hasAttr user config.users.users) users;
      message = "inventory.nix 里的用户未在 NixOS 账号中定义：${hostName}";
    }
  ];

  networking.hostName = hostName;
  system.stateVersion = lib.mkDefault "26.05";
}
