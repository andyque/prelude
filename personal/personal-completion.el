(prelude-require-packages '(ido-vertical-mode))

(require 'company)

(eval-after-load 'company
  '(progn
     (setq company-echo-delay 0)
     (setq company-idle-delay 0.08)
     (setq  company-tooltip-flip-when-above t)
     (setq company-auto-complete nil)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-tooltip-limit 10)
     (setq company-minimum-prefix-length 1)
     (setq  company-dabbrev-ignore-case nil)
     (setq  company-dabbrev-downcase nil)
     (setq company-require-match nil)
     ;; key bindings
     (define-key company-active-map (kbd "C-j") 'company-select-next)
     (define-key company-active-map (kbd "C-k") 'company-select-previous)
     (define-key company-active-map (kbd "C-/") 'company-search-candidates)))
     
     


;; configs for auto complete mode
;; (prelude-require-packages '(auto-complete
;;                             ))
;; (require 'auto-complete)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-compauto-complete-20140314.802/dict")

;; (require 'auto-complete-config)
;; (ac-config-default)

;; (setq ac-use-menu-map t)
;; ;; Default settings
;; (define-key ac-menu-map "\C-n" 'ac-next)
;; (define-key ac-menu-map "\C-p" 'ac-previous)

;; (global-auto-complete-mode t)
;; ;; extra modes auto-complete must support
;; (dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
;;                 sass-mode yaml-mode csv-mode espresso-mode haskell-mode
;;                 html-mode web-mode sh-mode smarty-mode clojure-mode
;;                 lisp-mode textile-mode markdown-mode tuareg-mode enh-ruby-mode python-mode
;;                 js2-mode css-mode less-css-mode))
;;   (add-to-list 'ac-modes mode))


;; (setq ac-auto-start 1)
;; (setq ac-ignore-case nil)
;; (ac-flyspell-workaround)

;; ;;; set the trigger key so that it can work together with yasnippet on tab key,
;; ;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; ;;; activate, otherwise, auto-complete will
;; ;;http://truongtx.me/2013/01/06/config-yasnippet-and-autocomplete-on-emacs/
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")


(ido-vertical-mode 1)
;;face config like abo-abo
(setq ido-vertical-show-count t)
(setq ido-use-faces t)
(set-face-attribute 'ido-vertical-first-match-face nil
                    :background "#e5b7c0")
(set-face-attribute 'ido-vertical-only-match-face nil
                    :background "#e52b50"
                    :foreground "white")
(set-face-attribute 'ido-vertical-match-face nil
                    :foreground "#b00000")

;; http://oremacs.com/2015/04/16/ivy-mode/
(require 'ivy)
;; (ivy-mode -1)
(setq magit-completing-read-function 'ivy-completing-read)

;; http://oremacs.com/2015/04/19/git-grep-ivy/
(defun counsel-git-grep-function (string &optional _pred &rest _u)
  "Grep in the current git repository for STRING."
  (split-string
   (shell-command-to-string
    (format
     "git --no-pager grep --full-name -n --no-color -i -e \"%s\""
     string))
   "\n"
   t))

(defun counsel-git-grep ()
  "Grep for a string in the current git repository."
  (interactive)
  (let ((default-directory (locate-dominating-file
                            default-directory ".git"))
        (val (ivy-read "pattern: " 'counsel-git-grep-function))
        lst)
    (when val
      (setq lst (split-string val ":"))
      (find-file (car lst))
      (goto-char (point-min))
      (forward-line (1- (string-to-number (cadr lst)))))))

(global-set-key (kbd "C-c j") 'counsel-git-grep)

;; Now I use ivy instead

(provide 'personal-completion)
