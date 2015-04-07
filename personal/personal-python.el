;;; Code:

(require 'prelude-programming)
(prelude-require-packages '(jedi
                            elpy
                            highlight-indentation
                            ))

(use-package jedi)
(use-package elpy)
(require 'epc)
(elpy-enable)
;; (require 'ipython)
;; in order to use elpy, we must install:  pip install elpy,jedi,epc,virutalenv,
;; c-c c-r   for refactoring
;; c-c c-e for simultaneous editing
;; c-c . for go to definitions
;; c-c ? for jedi doc
;; c-c / for all simbols
;; c-c c-o for overview all the definitions

(setq elpy-rpc-backend "jedi")
(setq eldoc-print-after-edit t)
(setq jedi:complete-on-dot t)
(setq jedi:tooltip-method '(post-tip))

(push "*jedi:doc*" popwin:special-display-config)

(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#849484")
(set-face-background 'highlight-indentation-current-column-face "#8F9AA8")

;; (add-hook 'python-mode-hook 'elpy-enable)
(add-hook 'python-mode-hook 'jedi:setup)

(provide 'personal-python)
;;; personal-python.el ends here
