;;; mainly for management windows

(prelude-require-packages '(switch-window
                            window-numbering))

;; http://tapoueh.org/emacs/switch-window.html
(require 'switch-window)

(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-, s 1") 'delete-other-windows)
(global-set-key (kbd "C-, s o") 'delete-other-window)


;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window
;;----------------------------------------------------------------------------
(defun split-window-func-with-other-buffer (split-function)
  (lexical-let ((s-f split-function))
    (lambda ()
      (interactive)
      (funcall s-f)
      (set-window-buffer (next-window) (other-buffer)))))

(global-set-key (kbd "C-, s2") (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key (kbd "C-, s3") (split-window-func-with-other-buffer 'split-window-horizontally))

(defun sanityinc/toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(global-set-key "\C-x1" 'sanityinc/toggle-delete-other-windows)

;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
(defun split-window-horizontally-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-horizontally))))

(defun split-window-vertically-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-vertically))))

(global-set-key "\C-x|" 'split-window-horizontally-instead)
(global-set-key "\C-x_" 'split-window-vertically-instead)

(require 'window-numbering)
;; highlight the window number in pink color
(custom-set-faces '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold)))))
(window-numbering-mode 1)

(define-key evil-normal-state-map ",1" 'select-window-1)
(define-key evil-normal-state-map ",2" 'select-window-2)
(define-key evil-normal-state-map ",3" 'select-window-3)
(define-key evil-normal-state-map ",4" 'select-window-4)

;; sometimes it's very anoyying
;; (desktop-save-mode 1)
;; popwin
;; http://emacs.stackexchange.com/questions/459/how-to-automatically-kill-helm-buffers-i-dont-need
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(push '("^\*helm .+\*$" :regexp t) popwin:special-display-config)
(push '("^\*helm-.+\*$" :regexp t) popwin:special-display-config)

(provide 'prelude-window)
