{ ... }:

{
  programs.hyprland.enable = true;

  # 内置 X11 兼容（常驻服务：按需唤醒，常驻内存）
  programs.hyprland.xwayland.enable = true;
}
