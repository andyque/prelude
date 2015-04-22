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
(require 'ace-jump-mode)
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

;; for edting glsl files
(prelude-require-packages '(glsl-mode))

;;; Code  setup input method

(add-to-list 'load-path "~/.emacs.d/site-lisp/eim")
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip nil)

(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt")
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "汉字拼音输入法" "py.txt")
;; 用 ; 暂时输入英文
(require 'eim-extra)
(global-set-key ";" 'eim-insert-ascii)


(defun evil-toggle-input-method ()
  "when toggle on input method, switch to evil-insert-state if possible.
when toggle off input method, switch to evil-normal-state if current state is evil-insert-state"
  (interactive)
  (if (not current-input-method)
      (if (not (string= evil-state "insert"))
          (evil-insert-state))
    (if (string= evil-state "insert")
        (evil-normal-state)
      ))
  (toggle-input-method))

(global-set-key (kbd "C-\\") 'evil-toggle-input-method)

;;add auto format paste code
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))


(provide 'prelude-misc)
;;; prelude-misc.el ends here
