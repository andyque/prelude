;;; Code:

;;; goto-chg lets you use the g-; and g-, to go to recent changes
;;; evil-visualstar enables searching visual selection with *
;;; evil-numbers enables vim style numeric incrementing and decrementing

(prelude-require-packages '(evil
                            goto-chg
                            evil-surround
                            evil-visualstar
                            evil-numbers
                            evil-leader
                            evil-matchit
                            evil-nerd-commenter
                            evil-jumper
                            evil-exchange
                            evil-anzu
                            evil-iedit-state
                            ))

(require 'evil-visualstar)
(global-evil-visualstar-mode t)

(setq evil-search-module 'evil-search)
(setq evil-mode-line-format 'before)

(setq evil-emacs-state-cursor  '("red" box))
(setq evil-normal-state-cursor '("gray" box))
(setq evil-visual-state-cursor '("gray" box))
(setq evil-insert-state-cursor '("gray" bar))
(setq evil-motion-state-cursor '("gray" box))

;; prevent esc-key from translating to meta-key in terminal mode
(setq evil-esc-delay 0)

(evil-mode 1)
(global-evil-surround-mode 1)

(defun evilcvn--change-symbol(fn)
  (let ((old (thing-at-point 'symbol)))
    (funcall fn)
    (unless (evil-visual-state-p)
      (kill-new old)
      (evil-visual-state))
    (evil-ex (concat "'<,'>s/" (if (= 0 (length old)) "" "\\<\\(") old (if (= 0 (length old)) "" "\\)\\>/"))))
  )

(defun evilcvn-change-symbol-in-whole-buffer()
  "mark the region in whole buffer and use string replacing UI in evil-mode
to replace the symbol under cursor"
  (interactive)
  (evilcvn--change-symbol 'mark-whole-buffer)
  )

(defun evilcvn-change-symbol-in-defun ()
  "mark the region in defun (definition of function) and use string replacing UI in evil-mode
to replace the symbol under cursor"
  (interactive)
  (evilcvn--change-symbol 'mark-defun)
  )

(defun prelude-yank-to-end-of-line ()
  "Yank to end of line."
  (interactive)
  (evil-yank (point) (point-at-eol)))


;; Scrolling
(defun prelude-evil-scroll-down-other-window ()
  (interactive)
  (scroll-other-window))

(defun prelude-evil-scroll-up-other-window ()
  (interactive)
  (scroll-other-window '-))

(setq evil-shift-width 2)
(defun prelude-shift-left-visual ()
  "Shift left and restore visual selection."
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun prelude-shift-right-visual ()
  "Shift right and restore visual selection."
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))



;; use , as my leader key
(global-evil-leader-mode)

;;config for evil-matchit
(require 'evil-matchit)
(global-evil-matchit-mode 1)

;;evil nerd commemter configs
(evilnc-default-hotkeys)

;; change  minibuffer color
(lexical-let ((default-color (cons (face-background 'mode-line)
				   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
	    (lambda ()
	      (let ((color (cond ((minibufferp) default-color)
				 ((evil-insert-state-p) '("#e80000" . "#ffffff"))
				 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
				 ((evil-normal-state-p)  '("#006fa0" . "#ffffff"))
				 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
				 (t default-color))))
		(set-face-background 'mode-line (car color))
		(set-face-foreground 'mode-line (cdr color))))))


(require 'evil-leader)
(setq evil-leader/leader "," evil-leader/in-all-states t)

(require 'evil-jumper)


;; evil highlight search
;; (require 'evil-search-highlight-persist)
;; (global-evil-search-highlight-persist t)
(require 'evil-anzu)

;;evil tab, it will cause other window blink which is really anoying
;; (global-evil-tabs-mode t)

;;evil ex-change
(require 'evil-exchange)
(evil-exchange-install)

;;mimic "nzz" behaviou in vim
(defadvice evil-ex-search-next (after advice-for-evil-search-next activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

(defadvice evil-ex-search-previous (after advice-for-evil-search-previous activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

;; ;; change evil initial mode state
(loop for (mode . state) in
      '(
        (minibuffer-inactive-mode . emacs)
        (Info-mode . normal)
        (term-mode . emacs)
        (log-edit-mode . emacs)
        (inf-ruby-mode . emacs)
        (yari-mode . emacs)
        (erc-mode . emacs)
        (gud-mode . emacs)
        (help-mode . emacs)
        (eshell-mode . emacs)
        (shell-mode . emacs)
        (rst-mode . emacs)
        (magit-log-edit-mode . emacs)
        (fundamental-mode . emacs)
        (gtags-select-mode . emacs)
        (weibo-timeline-mode . emacs)
        (elfeed-search-mode . emacs)
        (git-rebase-mode . emacs)
        (weibo-post-mode . emacs)
        (sr-mode . emacs)
        (dired-mode . emacs)
        (compilation-mode . emacs)
        (speedbar-mode . emacs)
        (magit-cherry-mode . emacs)
        (magit-commit-mode . normal)
        (magit-blame-mode . emacs)
        (rtags-mode . emacs)
        (js2-error-buffer-mode . emacs)
        (mu4e~update-mail-mode . emacs)
        (mu4e-about-mode . emacs)
        (epa-key-list-mode . emacs)
        (magit-commit-mode . emacs)
        (diff-mode . emacs)
        (makey-key-mode . emacs)
        (srefactor-ui-menu-mode . emacs)
        (eww-mode . emacs)
        (elfeed-show-mode . emacs)
        (fundamental-mode . normal)
        (weibo-image-mode . emacs)
        (sx-question-list-mode . emacs)
        (sx-question-mode . emacs)
        )
       
      do (evil-set-initial-state mode state))

;; (load-file "~/.emacs.d/personal/evil/mode-line-color.el")
;; (load-file "~/.emacs.d/personal/evil/linum+.el")
;; (load-file "~/.emacs.d/personal/evil/evil-ex-registers.el")
;; (load-file "~/.emacs.d/personal/evil/evil-mode-line.el")
;; (load-file "~/.emacs.d/personal/evil/evil-relative-linum.el")


;; (require 'evil-relative-linum)
;; (require 'evil-ex-registers)
;; (require 'evil-mode-line)
(require 'evil-iedit-state)

(provide 'prelude-evil)
