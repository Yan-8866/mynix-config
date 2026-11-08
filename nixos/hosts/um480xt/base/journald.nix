{ ... }:

{
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    SystemMaxFileSize=256M
  '';
}
