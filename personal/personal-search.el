(prelude-require-packages '(ag
                            helm-ag
                            wgrep-ag
                            ))

;; ignore some files searched by grep and ag
(require 'grep)
(eval-after-load 'grep
  '(progn
     (add-to-list 'grep-find-ignored-directories "savefile")
     (add-to-list 'grep-find-ignored-directories "elpa")))

;;helm-ag
(require 'helm-ag)
(defun projectile-helm-ag ()
  (interactive)
  (helm-ag (projectile-project-root)))
(setq helm-ag-always-set-extra-option t)

;; search for specify files  -G\.js for only js files   ignore Ignore IGNORE
;; -case-sensitive for case sensitive search
;; on default it will be smartcase search
(custom-set-variables
 '(helm-ag-base-command "ag --nocolor --nogroup --smart-case")
 '(helm-ag-command-option "--all-text")
 '(helm-ag-insert-at-point 'symbol))

;;config for ag and wgrep
(require 'ag)
;; use C-c C-e to start editing
;; http://conqueringthecommandline.com/book/ack_ag#chapter-ack-ag
(define-key ag-mode-map (kbd "C-c C-e") 'wgrep-change-to-wgrep-mode)

(provide 'personal-search)
