(prelude-require-packages '(macrostep
                            aggressive-indent
                            ))

(require 'macrostep)
(define-key prelude-mode-map (kbd "C-c e") nil)
(define-key emacs-lisp-mode-map (kbd "C-c e") 'macrostep-expand)

;; for aggressive-indent
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

(provide 'personal-elisp)
