{
  hostName,
  userName,
  ...
}:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      e = "emacsclient -n -a emacs";
      et = "emacsclient -t -a emacs";
      nix-switch = "sudo nixos-rebuild switch --flake .#${hostName}";
      hm-switch = "home-manager switch --flake .#${userName}@${hostName}";
    };
  };

  xdg.configFile."fish/conf.d/00-hm-session-vars-marker.fish".text = ''
    set -e __HM_SESS_VARS_SOURCED
  '';
}
