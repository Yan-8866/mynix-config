;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;; 【本人自建】TidalCycles live coding。
(package! tidal)

;; 使用 Nix 提供的 vterm / pdf-tools / gt，禁止 Doom 自行安装
(package! vterm :ignore t)
(package! pdf-tools :ignore t)
(package! gt :ignore t)
