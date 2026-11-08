(defun my-tidal-setup ()
  (when (fboundp #'interactive-haskell-mode)
    (interactive-haskell-mode -1))
  (unless (comint-check-proc tidal-buffer)
    (tidal-start-haskell)))

(defun my-tidal-toggle-window ()
  (interactive)
  (let ((w (get-buffer-window tidal-buffer t)))
    (if w
        (delete-window w)
      (display-buffer tidal-buffer))))

(defun my-tidal-send (s)
  (tidal-send-string ":{")
  (tidal-send-string (if tidal-literate-p (tidal-unlit s) s))
  (tidal-send-string ":}"))

(defun my-tidal-run-region ()
  (interactive)
  (my-tidal-send (buffer-substring-no-properties (region-beginning) (region-end))))

(defun my-tidal-run-buffer ()
  (interactive)
  (my-tidal-send (buffer-substring-no-properties (point-min) (point-max))))

(add-hook 'tidal-mode-hook #'my-tidal-setup)

(with-eval-after-load 'tidal
  (map! :map tidal-mode-map
        :localleader
        :desc "启动 Tidal"    "s"   #'tidal-start-haskell
        :desc "求值当前行"    "c"   #'tidal-run-line
        :desc "求值当前段落"  "e"   #'tidal-run-multiple-lines
        :desc "求值当前段落"  "RET" #'tidal-run-multiple-lines
        :desc "求值选中区域"  "r"   #'my-tidal-run-region
        :desc "求值整个文件"  "b"   #'my-tidal-run-buffer
        :desc "打断求值"      "i"   #'tidal-interrupt-haskell
        :desc "跑 main"       "m"   #'tidal-run-main
        :desc "全部静音"      "h"   #'tidal-hush
        :desc "显示/隐藏窗口" "v"   #'my-tidal-toggle-window
        :desc "退出 Tidal"    "q"   #'tidal-quit-haskell

        (:prefix ("d" . "求值第 N 轨（跳到文中 dN 处）")
         "1" #'tidal-run-d1
         "2" #'tidal-run-d2
         "3" #'tidal-run-d3
         "4" #'tidal-run-d4
         "5" #'tidal-run-d5
         "6" #'tidal-run-d6
         "7" #'tidal-run-d7
         "8" #'tidal-run-d8
         "9" #'tidal-run-d9
         "0" #'tidal-run-d10)

        (:prefix ("k" . "静音第 N 轨")
         "1" #'tidal-stop-d1
         "2" #'tidal-stop-d2
         "3" #'tidal-stop-d3
         "4" #'tidal-stop-d4
         "5" #'tidal-stop-d5
         "6" #'tidal-stop-d6
         "7" #'tidal-stop-d7
         "8" #'tidal-stop-d8
         "9" #'tidal-stop-d9
         "0" #'tidal-stop-d10)))

(set-popup-rule! "^\\*tidal\\*$" :side 'bottom :size 0.3 :quit nil :select nil)
