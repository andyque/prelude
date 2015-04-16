;;; Code:

(prelude-require-packages '(helm-swoop
                            ))

(require 'helm-misc)
(require 'helm-config)
(require 'helm-swoop)

;; (defun helm-prelude ()
;;   "Preconfigured `helm'."
;;   (interactive)
;;   (condition-case nil
;;       (if (projectile-project-root)
;;           (helm-projectile)
;;         ;; otherwise fallback to `helm-mini'
;;         (helm-mini))
;;     ;; fall back to helm mini if an error occurs (usually in `projectile-project-root')
;;     (error (helm-mini))))

;; (eval-after-load 'prelude-mode
;;   '(progn
;;      (define-key prelude-mode-map (kbd "C-c h") 'helm-prelude)
;;      (easy-menu-add-item nil '("Tools" "Prelude")
;;                          '("Navigation"
;;                            ["Helm" helm-prelude]))))
;; (push "Press <C-c h> to navigate a project in Helm." prelude-tips)


;; (helm-mode 1)
(setq helm-completing-read-handlers-alist
      '((describe-function . ido)
        (describe-variable . ido)
        (debug-on-entry . helm-completing-read-symbols)
        (find-function . helm-completing-read-symbols)
        (find-tag . helm-completing-read-with-cands-in-buffer)
        (ffap-alternate-file . nil)
        (tmm-menubar . nil)
        (dired-do-copy . nil)
        (dired-do-rename . nil)
        (dired-create-directory . nil)
        (find-file . ido)
        (copy-file-and-rename-buffer . nil)
        (rename-file-and-buffer . nil)
        (w3m-goto-url . nil)
        (ido-find-file . nil)
        (ido-edit-input . nil)
        (mml-attach-file . ido)
        (read-file-name . nil)
        (yas/compile-directory . ido)
        (execute-extended-command . ido)
        (minibuffer-completion-help . nil)
        (minibuffer-complete . nil)
        (c-set-offset . nil)
        (wg-load . ido)
        (rgrep . nil)
        (read-directory-name . ido)
        ))


(use-package helm-ls-git
  :config
  (setq helm-ls-git-show-abs-or-relative 'relative))


(provide 'personal-helm)
