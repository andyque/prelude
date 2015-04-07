;;; package --- personal global key-binding configuration
;;; Commentary:
;;; Code:

(prelude-require-packages '(keyfreq
                            ido-occasional
                            helm-ls-git
                            swiper
                            ))
(require 'personal-tools)

(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "C-:") 'dired-jump)
(define-key org-mode-map (kbd "<s-return>") 'org-meta-return)


;; track emacs commands frequency
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(global-set-key "\C-s" 'swiper)


(global-set-key (kbd "C-h f") (with-ido-completion describe-function ))
(global-set-key (kbd "C-h C-f") (with-ido-completion find-function ))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "s-t") 'helm-ls-git-ls)
(global-set-key (kbd "s-w") 'delete-window)


(global-set-key (kbd "C-c w") 'weibo-timeline)

(global-set-key (kbd "<f1>") 'hotspots)


(global-set-key (kbd "C-c h") 'hydra-apropos/body)

;; stackoverflow settings
(global-set-key (kbd "C-c l") 'zilongshanren/insert-chrome-current-tab-url)

(provide 'personal-global-keybinding)
