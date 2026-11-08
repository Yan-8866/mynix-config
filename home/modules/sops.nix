{
  inputs,
  userName,
  isNixos,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.defaultSopsFile = ../../secrets/users/${userName}.yaml;
  sops.age.keyFile =
    if isNixos then "/etc/sops/age/keys.txt" else "${config.xdg.configHome}/sops/age/keys.txt";
}
