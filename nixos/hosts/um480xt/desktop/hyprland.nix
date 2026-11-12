{ lib, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # tuigreet 自行扫描 XDG_DATA_DIRS，不需要 sessionPackages；
  # 置空可避免 hyprland 的 .desktop 在系统路径和 desktops/share 里各出现一次
  services.displayManager.sessionPackages = lib.mkForce [ ];
}
