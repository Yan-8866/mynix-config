;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       ;; 默认开启
       (corfu +orderless)              ; 行内补全；+orderless 空格分词、顺序随意
       vertico                         ; 迷你缓冲区补全

       :ui
       ;; 默认开启
       doom                            ; Doom 主题与 UI 基础
       dashboard                       ; 启动仪表盘
       hl-todo                         ; 高亮 TODO/FIXME 等
       modeline                        ; 状态栏
       ophints                         ; 操作反馈高亮
       (popup +defaults)               ; 弹窗管理；+defaults 使用默认规则
       (vc-gutter +pretty)             ; Git 边栏 diff 标记；+pretty 美化图标
       vi-tilde-fringe                 ; 缓冲区末尾显示 ~
       workspaces                      ; 工作区（保存/切换窗口布局）
       ;; 默认关闭
       (window-select +numbers)        ; 窗口选择；+numbers 显示数字标签，按数字跳窗口
       treemacs                        ; 文件树侧边栏

       :editor
       ;; 默认开启
       (evil +everywhere)              ; Vim 键位；+everywhere 全局启用
       file-templates                  ; 空文件自动模板
       fold                            ; 代码折叠
       (format +onsave)                ; 代码格式化；+onsave 保存时自动格式化
       snippets                        ; 代码片段
       (whitespace +guess +trim)       ; 空白管理；+guess 推测缩进、+trim 去尾随空格

       :emacs
       ;; 默认开启
       dired                           ; 文件管理器
       electric                        ; 智能缩进
       tramp                           ; 远程文件访问
       undo                            ; 持久化/增强撤销
       vc                              ; 版本控制集成

       :term
       ;; 默认关闭
       vterm                           ; Emacs 内终端模拟（几乎最好用）

       :checkers
       ;; 默认开启
       syntax                          ; 语法检查

       :tools
       ;; 默认开启
       (eval +overlay)                 ; 运行代码/REPL；+overlay 内联结果
       lookup                          ; 代码与文档导航
       magit                           ; Git porcelain
       ;; 默认关闭
       editorconfig                    ; 跨编辑器统一编辑配置
       (pdf)                           ; PDF 阅读（pdf-tools）；批注默认启用
       lsp                             ; 语言服务器协议（LSP）
       ;; 未来开启
       ;;make                          ; 从 Emacs 运行 make 任务
       ;;tree-sitter                   ; 语法解析与高亮
       ;;debugger                      ; 代码调试

       :os
       ;; 默认开启
       (:if (featurep :system 'macos) macos) ; macOS 兼容增强（NixOS 下不生效）

       :lang
       ;; 默认开启
       emacs-lisp                      ; Emacs Lisp
       markdown                        ; Markdown 文档
       org                             ; Org 笔记/日程
       sh                              ; Shell 脚本
       ;; 默认关闭
       (cc +lsp)                       ; C/C++；+lsp 启用语言服务器
       (nix +lsp)                      ; Nix 配置支持；+lsp 启用语言服务器
       (rust +lsp)                     ; Rust；+lsp 启用语言服务器
       json                            ; At least it ain't XML

       :email

       :app

       :config
       ;; 默认开启
       (default +bindings +smartparens) ; 默认配置；+bindings 键位、+smartparens 智能括号

)

