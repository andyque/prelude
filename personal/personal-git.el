;; disable all vc backends
;; @see http://stackoverflow.com/questions/5748814/how-does-one-disable-vc-git-in-emacs
(prelude-require-packages '(git-gutter
                            git-messenger
                            ))

(setq magit-save-some-buffers nil
      magit-process-popup-time 10
      magit-completing-read-function 'magit-ido-completing-read)


;; Sometimes I want check other developer's commit
;; show file of specific version
(autoload 'magit-show "magit" "" t nil)
;; show the commit
(autoload 'magit-show-commit "magit" "" t nil)


(eval-after-load 'magit
  '(progn
     ;; Don't let magit-status mess up window configurations
     ;; http://whattheemacsd.com/setup-magit.el-01.html
     (defadvice magit-status (around magit-fullscreen activate)
       (window-configuration-to-register :magit-fullscreen)
       ad-do-it
       (delete-other-windows))

     (defun magit-quit-session ()
       "Restores the previous window configuration and kills the magit buffer"
       (interactive)
       (kill-buffer)
       (jump-to-register :magit-fullscreen))

     (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)))

(when *is-a-mac*
  (add-hook 'magit-mode-hook (lambda () (local-unset-key [(meta h)]))))

(eval-after-load 'magit
  '(progn
     (require 'magit-key-mode)
     ))

(require 'git-gutter)
(global-git-gutter-mode t)
(diminish 'git-gutter-mode)


(defadvice magit-blame-mode (after magit-blame-change-to-emacs-state activate compile)
  "when entering magit blame mode, change evil normal state to emacs state"
  (if (evil-normal-state-p)
      (evil-emacs-state)
    (evil-normal-state))
  )

(ad-activate 'magit-blame-mode)

(defadvice git-timemachine-mode (after git-timemachine-change-to-emacs-state activate compile)
  "when entering git-timemachine mode, change evil normal state to emacs state"
  (if (evil-normal-state-p)
      (evil-emacs-state)
    (evil-normal-state)))

(ad-activate 'git-timemachine-mode)

;;configs for magit-filenotify-mode we should compile emacs with filenotify-support
;; (require 'magit-filenotify)
;; (add-hook 'magit-status-mode-hook (lambda ()(magit-filenotify-mode)))

;; configs for github pull request
;FIXME: very slow in China, it's useless now.
;; (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
;; http://oremacs.com/2015/03/11/git-tricks/
(setq magit-repo-dirs
      (mapcar
       (lambda (dir)
         (substring dir 0 -1))
       (cl-remove-if-not
        (lambda (project)
          (unless (file-remote-p project)
            (file-directory-p (concat project "/.git/"))))
        (projectile-relevant-known-projects))))

;; Githu PR settings
;;http://endlessparentheses.com/easily-create-github-prs-from-magit.html
(defun endless/visit-pull-request-url ()
  "Visit the current branch's PR on Github."
  (interactive)
  (browse-url
   (format "https://github.com/%s/compare/%s"
           (replace-regexp-in-string
            "\\`.+github\\.com:\\(.+\\)\\.git\\'" "\\1"
            (magit-get "remote"
                       (magit-get-current-remote)
                       "url"))
           (magit-get-current-branch))))

(eval-after-load 'magit
  '(define-key magit-mode-map "V"
     #'endless/visit-pull-request-url))


;; show commit message of current line
(require 'git-messenger) ;; You need not to load if you install with package.el
(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)
(global-set-key (kbd "C-c v") 'git-messenger:popup-message)

(define-key git-messenger-map (kbd "m") 'git-messenger:copy-message)
(define-key git-messenger-map (kbd "b") 'github-browse-file)

;; Enable magit-commit-mode after typing 's', 'S', 'd'
(add-hook 'git-messenger:popup-buffer-hook 'magit-commit-mode)

(defun my-vc-visit-file-revision (file rev)
  "Visit revision REV of FILE in another window.
With prefix argument, uses the current window instead.
If the current file is named `F', the revision is named `F.~REV~'.
If `F.~REV~' already exists, use it instead of checking it out again."
  ;; based on `vc-revision-other-window'.
  (interactive
   (let ((file (expand-file-name
                (read-file-name
                 (if (buffer-file-name)
                     (format "File (%s): " (file-name-nondirectory
                                            (buffer-file-name)))
                   "File: ")))))
     (require 'vc)
     (unless (vc-backend file)
       (error "File %s is not under version control" file))
     (list file (vc-read-revision
                 "Revision to visit (default is working revision): "
                 (list file)))))
  (require 'vc)
  (unless (vc-backend file)
    (error "File %s is not under version control" file))
  (let ((revision (if (string-equal rev "")
                      (vc-working-revision file)
                    rev))
        (visit (if current-prefix-arg
                   'switch-to-buffer
                 'switch-to-buffer-other-window)))
    (funcall visit (vc-find-revision file revision))))

(define-key git-messenger-map (kbd "f") 'my-vc-visit-file-revision)

;; }}
(provide 'prelude-git)
