(prelude-require-packages '(macrostep
                            use-package
                            ))

(require use-package)
(use-package sh-script
  :defer t
  :config
  (progn
    ;; recognize pretzo files as zsh scripts
    (defvar prelude-pretzo-files '("zlogin" "zlogin" "zlogout" "zpretzorc" "zprofile" "zshenv" "zshrc"))
    (mapc (lambda (file)
            (add-to-list 'auto-mode-alist `(,(format "\\%s\\'" file) . sh-mode)))
          prelude-pretzo-files)
    (add-hook 'sh-mode-hook
              (lambda ()
                (if (and buffer-file-name
                         (member (file-name-nondirectory buffer-file-name) prelude-pretzo-files))
                    (sh-set-shell "zsh"))))
    (require 'yasnippet)
    (add-hook 'term-mode-hook (lambda()
                                (setq yas-dont-activate t)))

    (defun ash-term-hooks ()
      ;; dabbrev-expand in term
      (define-key term-raw-escape-map "/"
        (lambda ()
          (interactive)
          (let ((beg (point)))
            (dabbrev-expand nil)
            (kill-region beg (point)))
          (term-send-raw-string (substring-no-properties (current-kill 0)))))
      ;; yank in term (bound to C-c C-y)
      (define-key term-raw-escape-map "\C-y"
        (lambda ()
          (interactive)
          (term-send-raw-string (current-kill 0)))))
    (add-hook 'term-mode-hook 'ash-term-hooks)

    (eval-after-load 'term'
      (define-key term-raw-map (kbd "C-:") 'dired-jump)
      )
    ))
