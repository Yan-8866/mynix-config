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
;; 符号树挪到右侧，避免和 treemacs 抢左侧
(after! lsp-treemacs
  (setq lsp-treemacs-symbols-position-params
        '((side . right) (slot . 1) (window-width . 32))))

;; grammar 全由 Nix 提供，缺失时回退而非尝试安装
(setq treesit-auto-install-grammar nil)

;; Shell 使用 bash-ts-mode（Doom 的 sh 模块没有 +tree-sitter flag）
(set-tree-sitter! 'sh-mode 'bash-ts-mode 'bash)
(add-hook 'bash-ts-mode-local-vars-hook #'lsp! 'append)

;; 本人自建
(load! "lisp/keys")
(load! "lisp/tidal")

;; 划词/选区翻译：gt（原 go-translate），包由 Nix 提供
(use-package! gt
  :config
  (setq gt-langs '(en zh)
        gt-buffer-render-window-config nil
        gt-default-translator (gt-translator :engines (gt-bing-engine)
                                            :render (gt-buffer-render))))
(set-popup-rules! '(("^\\*gt-result\\*$" :side bottom :size 0.3 :select nil :quit t)))
(map! :leader :desc "翻译" "t t" #'gt-translate)

;; Markdown 预览留在 Emacs 内：只有本地 file:// 交给 eww，网页链接仍走系统浏览器
(setq browse-url-handlers '(("^file://" . eww-browse-url)))
