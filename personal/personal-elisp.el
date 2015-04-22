(prelude-require-packages '(aggressive-indent
                            lispy))

;; it will conflicts with lispy
;; (require 'macrostep)
;; (define-key prelude-mode-map (kbd "C-c e") nil)
;; (define-key emacs-lisp-mode-map (kbd "C-c e") 'macrostep-expand)

;; for aggressive-indent
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

(provide 'personal-elisp)
