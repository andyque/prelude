;;; package --- personal global key-binding configuration
;;; Commentary:
;;; Code:

(prelude-require-packages '(keyfreq
                            ido-occasional
                            helm-ls-git
                            swiper
                            ))
(require 'personal-tools)

;; http://shallowsky.com/blog/linux/editors/emacs-global-key-bindings.html
;; (defvar global-keys-minor-mode-map (make-sparse-keymap)
;;   "global-keys-minor-mode keymap.")

;; (define-minor-mode global-keys-minor-mode
;;   "A minor mode so that global key settings override annoying major modes."
;;   t " global-keys" 'global-keys-minor-mode-map)

;; (global-keys-minor-mode 1)
;; (diminish 'global-keys-minor-mode)

;; A keymap that's supposed to be consulted before the first
;; minor-mode-map-alist.
;; (defconst global-minor-mode-alist (list (cons 'global-keys-minor-mode
;;                                               global-keys-minor-mode-map)))
(defconst prelude-minor-mode-alist (list (cons 'prelude-mode
                                               prelude-mode-map)))

(setf emulation-mode-map-alists '(prelude-minor-mode-alist))
(defun my-minibuffer-setup-hook ()
  (prelude-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; TRACK emacs commands frequency
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(define-key prelude-mode-map (kbd "C-s") 'swiper)
(define-key prelude-mode-map (kbd "C-c d") 'dash-at-point)
;; (define-key prelude-mode-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "s-t") 'helm-ls-git-ls)
(global-set-key (kbd "s-w") 'delete-window)
;;for the C-s-f only work for the right CMD key and it does for C-s-b
(global-set-key (kbd "<C-s-268632070>") 'sp-forward-sexp)
(global-set-key (kbd "<C-s-268632066>") 'sp-backward-sexp)
;; (define-key prelude-mode-map (kbd "s-t") 'helm-ls-git-ls)
;; (define-key prelude-mode-map (kbd "s-w") 'delete-window)
(define-key prelude-mode-map (kbd "C-:")'dired-jump)
(define-key prelude-mode-map (kbd "C-c y") 'youdao-dictionary-search-at-point+)
(define-key prelude-mode-map (kbd "C-h f") (with-ido-completion describe-function ))
(define-key prelude-mode-map (kbd "C-h C-f") (with-ido-completion find-function ))
(define-key prelude-mode-map (kbd "C-c w") 'weibo-timeline)
(define-key prelude-mode-map (kbd "<f1>") 'hotspots)
(define-key prelude-mode-map (kbd "C-c h") 'hydra-apropos/body)
(define-key prelude-mode-map (kbd "C-c l") 'zilongshanren/insert-chrome-current-tab-url)

(provide 'personal-global-keybinding)
