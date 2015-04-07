;; package --- personal tags configuration
;;; Commentary: For ctags, etags, gtags etc
;;; Code:

(prelude-require-packages '(ctags
                            ggtags
                            helm-gtags
                            ))

(require 'ctags)
;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)
;; Do case-sensitive tag searches
(setq tags-case-fold-search nil) ;; t=case-insensitive, nil=case-sensitive
;; Don't warn when TAGS files are large
(setq large-file-warning-threshold nil)



(when *is-a-mac*
  ;; Mac's default ctags does not support -e option
  ;; If you install Emacs by homebrew, another version of etags is already installed which does not need -e too
  (setq ctags-command "/usr/local/bin/ctags -e -R ") ;; the best option is to install latest ctags from sf.net
  )

(setq-local hippie-expand-try-functions-list
            (cons 'ggtags-try-complete-tag hippie-expand-try-functions-list))

;; helm-gtags
(setq helm-gtags-path-style 'relative)
(setq helm-gtags-ignore-case t)
(setq helm-gtags-auto-update t)

(require 'diminish)
(require 'helm-gtags)


(add-hook 'c++-mode-hook (lambda () (progn
                                     (helm-gtags-mode t)
                                     (diminish 'helm-gtags-mode)
                                     )))
;; }}

(provide 'personal-tags)
;;; personal-tags.el ends here
