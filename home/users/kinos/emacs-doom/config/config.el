;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; 默认设置
;; (setq doom-theme 'doom-one)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")

;; 本人设置
;; Doom Gruvbox 主题
(setq doom-theme 'doom-gruvbox)
;; Treemacs 文件预览
(after! treemacs
  (treemacs-peek-mode 1))

;; 本人自建
(load! "lisp/keys")
(load! "lisp/tidal")
