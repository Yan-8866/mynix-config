;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; 默认设置
;; (setq doom-theme 'doom-one)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")

;; 本人设置
;; Doom Gruvbox 主题
(setq doom-theme 'doom-gruvbox)
(setq nerd-icons-font-family "JetBrainsMono Nerd Font")
;; Treemacs 文件预览
(after! treemacs
  (treemacs-peek-mode 1))

;; grammar 全由 Nix 提供，缺失时回退而非尝试安装
(setq treesit-auto-install-grammar nil)

;; Shell 使用 bash-ts-mode（Doom 的 sh 模块没有 +tree-sitter flag）
(set-tree-sitter! 'sh-mode 'bash-ts-mode 'bash)
(add-hook 'bash-ts-mode-local-vars-hook #'lsp! 'append)

;; 本人自建
(load! "lisp/keys")
(load! "lisp/tidal")
