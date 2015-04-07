;;;misc settings for eamcs
;;;code;

;;; configs for multiple-cursors mode
(prelude-require-packages '(multiple-cursors))

(eval-after-load 'evil
  (progn
       (add-hook 'multiple-cursors-mode-enabled-hook 'evil-emacs-state)
       (add-hook 'multiple-cursors-mode-disabled-hook 'evil-normal-state)
       ))

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-.") 'mc/mark-all-like-this)


;;; configs for ace-jump mode
(setq ace-jump-mode-scope 'window)
(global-set-key (kbd "C-c SPC") 'ace-jump-word-mode)

(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set)
                'set-default)
            ',variable ,value))

(csetq ediff-window-setup-function 'ediff-setup-windows-plain)

(csetq ediff-split-window-function 'split-window-horizontally)

(defun ora-ediff-hook ()
  (ediff-setup-keymap)
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))

(add-hook 'ediff-mode-hook 'ora-ediff-hook)

(winner-mode)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)


(defun terminal ()
  "Switch to terminal. Launch if nonexistent."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/zsh"))
  (get-buffer-process "*ansi-term*"))

(defalias 'tt 'terminal)

;; redefine recenter


(defun swiper-recenter-top-bottom (&optional arg)
  "Call (`recenter-top-bottom' ARG) in `swiper--window'."
  (interactive "P")
  (with-selected-window swiper--window
    (recenter-top-bottom arg)))

(use-package swiper
  :config
  (define-key swiper-map (kbd "C-l") 'swiper-recenter-top-bottom))

(setq recenter-positions '(top middle bottom))


(provide 'prelude-misc)
;;; prelude-misc.el ends here
