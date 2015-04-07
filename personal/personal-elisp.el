(prelude-require-packages '(macrostep))

(require 'macrostep)
(define-key prelude-mode-map (kbd "C-c e") nil)
(define-key emacs-lisp-mode-map (kbd "C-c e") 'macrostep-expand)
