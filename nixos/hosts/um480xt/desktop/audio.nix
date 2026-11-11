{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true; # 启用核心
    alsa.enable = true; # ALSA 兼容层
    pulse.enable = true; # PulseAudio 兼容层
    jack.enable = true; # JACK 兼容层（audio.enable 不含）
    wireplumber.enable = true; # 会话管理器（必需）
  };
}
