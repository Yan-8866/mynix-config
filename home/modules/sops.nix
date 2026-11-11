{
  inputs,
  userName,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.defaultSopsFile = ../../secrets/users/${userName}.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
}
