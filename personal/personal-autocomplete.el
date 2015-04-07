(prelude-require-packages '(auto-complete
                            ))
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-compauto-complete-20140314.802/dict")

(require 'auto-complete-config)
(ac-config-default)

(setq ac-use-menu-map t)
;; Default settings
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

(global-auto-complete-mode t)
;; extra modes auto-complete must support
(dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                html-mode web-mode sh-mode smarty-mode clojure-mode
                lisp-mode textile-mode markdown-mode tuareg-mode enh-ruby-mode python-mode
                js2-mode css-mode less-css-mode))
  (add-to-list 'ac-modes mode))


(setq ac-auto-start 1)
(setq ac-ignore-case nil)
(ac-flyspell-workaround)

;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
;;http://truongtx.me/2013/01/06/config-yasnippet-and-autocomplete-on-emacs/
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")



(provide 'prelude-autocomplete)
