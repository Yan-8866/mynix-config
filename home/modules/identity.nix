{ userName, lib, ... }:
{
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = lib.mkDefault "26.05";
  };
}
