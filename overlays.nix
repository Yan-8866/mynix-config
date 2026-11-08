{ inputs }:
[
  inputs.emacs-overlay.overlays.default
  inputs.nur.overlays.default
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = prev.config;
    };
  })
]
