{ ... }:
{
  imports = [
    ./cli/dev.nix
    ./cli/github.nix
    ./cli/opencode.nix
    ./shell/fish.nix
    ./shell/starship.nix
    ./tui/bilibili-tui.nix
    ./tui/go-musicfox.nix
    ./tui/tidal-cycles.nix
    ./desktop/kitty.nix
    ./desktop/chromium.nix
    ./desktop/hyprland.nix
    ./desktop/fcitx5.nix
    ./emacs-doom/module.nix
  ];
}
