{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts."jetbrains-mono"
      sarasa-gothic
      inter
      literata
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Sarasa Mono SC"
      ];
      sansSerif = [
        "Inter"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Literata"
        "Noto Serif CJK SC"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
