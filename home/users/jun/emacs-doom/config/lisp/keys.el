;;; keys.el -*- lexical-binding: t; -*-

;; 【本人自建】解绑 SPC w 下与不带 Ctrl 键重复的 Ctrl 版。
(after! evil
  (map! :map evil-window-map
        "C-h" nil "C-j" nil "C-k" nil "C-l" nil
        "C-v" nil "C-s" nil "C-S-s" nil
        "C-n" nil "C-q" nil "C-p" nil "C-b" nil "C-t" nil "C-f" nil
        "C-=" nil "C-_" nil "C-x" nil
        "C-S-h" nil "C-S-j" nil "C-S-k" nil "C-S-l" nil
        "C-S-r" nil "C-S-W" nil
        "C-c" nil "C-u" nil))

(after! which-key
  (which-key-add-key-based-replacements
    ;; ---- SPC w 窗口：分屏与关闭 ----
    "SPC w v"     "左右劈开"
    "SPC w s"     "上下劈开"
    "SPC w V"     "左右劈开并跟随"
    "SPC w S"     "上下劈开并跟随"
    "SPC w n"     "新开一块空白"
    "SPC w d"     "关掉这块"
    "SPC w c"     "关掉这块（同 d）"
    "SPC w C-C"   "挑一块杀掉"
    "SPC w q"     "退出（先关块，再关窗口）"
    "SPC w T"     "拆成独立 Emacs 窗口"
    ;; ---- SPC w 窗口：光标移动 ----
    "SPC w h"     "挪到左边"
    "SPC w j"     "挪到下边"
    "SPC w k"     "挪到上边"
    "SPC w l"     "挪到右边"
    "SPC w 1"     "跳 1 号块"
    "SPC w 2"     "跳 2 号块"
    "SPC w 3"     "跳 3 号块"
    "SPC w 4"     "跳 4 号块"
    "SPC w 5"     "跳 5 号块"
    "SPC w 6"     "跳 6 号块"
    "SPC w 7"     "跳 7 号块"
    "SPC w 8"     "跳 8 号块"
    "SPC w 9"     "跳 9 号块"
    "SPC w 0"     "跳 0 号 / 第 10 块"
    "SPC w C-w"     "切到另一块"
    "SPC w w"     "下一块"
    "SPC w W"     "上一块"
    "SPC w p"     "最近用过的那块"
    "SPC w t"     "左上角那块"
    "SPC w b"     "右下角那块"
    "SPC w f"     "在另一块打开光标下路径"
    ;; ---- SPC w 窗口：调整大小 ----
    "SPC w +"     "加高"
    "SPC w -"     "减高"
    "SPC w >"     "加宽"
    "SPC w <"     "减宽"
    "SPC w _"     "高度设为 N 行"
    "SPC w |"     "宽度设为 N 列"
    "SPC w ="     "均分大小"
    ;; ---- SPC w 窗口：搬动与交换 ----
    "SPC w H"     "整块挪到最左"
    "SPC w J"     "整块挪到最下"
    "SPC w K"     "整块挪到最上"
    "SPC w L"     "整块挪到最右"
    "SPC w r"     "顺时针轮一圈"
    "SPC w R"     "逆时针轮一圈"
    "SPC w x"     "与下一块互换"
    "SPC w C-S-w" "挑两块互换"
    ;; ---- SPC w 窗口：最大化 ----
    "SPC w o"     "撑到最大（挤走其他）"
    "SPC w C-o"   "删掉其他所有块"
    "SPC w m"     "最大化"
    "SPC w m m"   "独占全屏"
    "SPC w m v"   "只删上下方向"
    "SPC w m s"   "只删左右方向"
    ;; ---- SPC w 窗口：撤销 ----
    "SPC w u"     "撤销布局改动"
    "SPC w C-r"   "重做布局改动"
    ;; ---- SPC w 窗口：其它 ----
    "SPC w :"     "输入命令（ex）"
    "SPC w g"     "标签页"
    "SPC w gt"    "下一个标签页"
    "SPC w gT"    "上一个标签页"

    ;; ---- SPC b Buffer ----
    "SPC b b"     "切换 buffer（当前 workspace）"
    "SPC b B"     "切换 buffer（全部）"
    "SPC ,"       "切换 buffer（当前 workspace）"
    "SPC b l"     "回到上一次看的"
    "SPC b ["     "上一个"
    "SPC b ]"     "下一个"
    "SPC b p"     "上一个"
    "SPC b n"     "下一个"
    "SPC b i"     "buffer 列表"
    "SPC b I"     "buffer 列表（仅当前 workspace）"
    "SPC b z"     "沉到最底"
    "SPC b y"     "复制整篇内容"
    "SPC b s"     "保存"
    "SPC b S"     "全部保存"
    "SPC b u"     "用 root 权限保存"
    "SPC b r"     "重读磁盘内容"
    "SPC b R"     "改 buffer 名字"
    "SPC b d"     "关掉当前"
    "SPC b k"     "关掉当前（同 d）"
    "SPC b O"     "只留当前，其余全关"
    "SPC b K"     "全部关掉"
    "SPC b Z"     "关掉沉底的一批"
    "SPC b N"     "新建空 buffer"
    "SPC b c"     "克隆（留在当前块）"
    "SPC b C"     "克隆并放到另一块"
    "SPC b x"     "呼出草稿区"
    "SPC b X"     "切到草稿区"
    "SPC b m"     "存书签"
    "SPC b M"     "删书签"
    "SPC b -"     "只显示选中部分"

    ;; ---- SPC f 文件 ----
    "SPC f f"     "打开文件"
    "SPC f F"     "从当前目录找文件"
    "SPC f r"     "最近打开的文件"
    "SPC f d"     "打开目录"
    "SPC f s"     "保存"
    "SPC f S"     "另存为"
    "SPC f R"     "重命名 / 移动当前文件"
    "SPC f C"     "复制当前文件"
    "SPC f D"     "删除当前文件"
    "SPC f y"     "复制文件路径"
    "SPC f Y"     "复制相对项目的路径"
    "SPC f u"     "用 root 打开文件"
    "SPC f U"     "用 root 打开当前文件"
    "SPC f e"     "在 emacs.d 里找文件"
    "SPC f E"     "浏览 emacs.d"
    "SPC f p"     "在 Doom 配置里找文件"
    "SPC f P"     "打开 Doom 配置目录"
    "SPC f l"     "locate 搜文件"

    "SPC f c"     "打开项目的 editorconfig"
))
