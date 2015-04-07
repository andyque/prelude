(prelude-require-packages '(fill-column-indicator
                            relative-line-numbers
                            powerline
                            powerline-evil
                            use-package
                            ws-butler
                            popwin
                            ))

;; config emacs theme
;; salorized color theme would make org-mode very slow
(require 'zenburn-theme)
(if window-system
    (load-theme 'zenburn t)
  (load-theme 'wombat t)
)

;;show git branch name in mode line
(defadvice vc-git-mode-line-string (after plus-minus (file) compile activate)
  (setq ad-return-value
        (concat ad-return-value
                (let ((plus-minus (vc-git--run-command-string
                                   file "diff" "--numstat" "--")))
                  (and plus-minus
                       (string-match "^\\([0-9]+\\)\t\\([0-9]+\\)\t" plus-minus)
                       (format " +%s-%s" (match-string 1 plus-minus) (match-string 2 plus-minus)))))))

(require 'powerline)
(powerline-evil-center-color-theme)

(custom-theme-set-faces 'zenburn
                        `(region ((t :background "#A9F5F2"))))
;;display time in mode line
(defface egoge-display-time
  '((((type x w32 mac))
     ;; #060525 is the background colour of my default face.
     (:foreground "#060525" :inherit bold))
    (((type tty))
     (:foreground "yellow")))
  "Face used to display the time in the mode line.")

;; This causes the current time in the mode line to be displayed in
;; `egoge-display-time-face' to make it stand out visually.
(setq display-time-string-forms
      '((propertize (concat " " 24-hours ":" minutes " ")
 		    'face 'egoge-display-time)))
(display-time-mode 1)

;; In terminal this settings is not correct.
(when (fboundp 'scroll-bar-mode)
(scroll-bar-mode -1)
  )

;; (setq-default show-trailing-whitespace -1)
(setq-default indicate-empty-lines t)
;; delete trailing-whitespace
;; (global-linum-mode t)
;; it's very slow when the file is very large
;; (global-relative-line-numbers-mode t)

;;http://stackoverflow.com/questions/3875213/ \
;;turning-on-linum-mode-when-in-python-c-mode
;;don't display linum in the following major mode
;; (setq linum-mode-inhibit-modes-list '(eshell-mode
;;                                       shell-mode
;;                                       erc-mode
;;                                       help-mode
;;                                       text-mode
;;                                       fundamental-mode
;;                                       jabber-roster-mode
;;                                       jabber-chat-mode
;;                                       twittering-mode
;;                                       compilation-mode
;;                                       weibo-timeline-mode
;;                                       woman-mode
;;                                       Info-mode
;;                                       calc-mode
;;                                       calc-trail-mode
;;                                       comint-mode
;;                                       gnus-group-mode
;;                                       inf-ruby-mode
;;                                       gud-mode
;;                                       vc-git-log-edit-mode
;;                                       log-edit-mode
;;                                       cmake-mode
;;                                       term-mode
;;                                       w3m-mode
;;                                       speedbar-mode
;;                                       org-agenda-mode
;;                                       gnus-summary-mode
;;                                       gnus-article-mode
;;                                       magit-status-mode
;;                                       calendar-mode))

;; (defadvice linum-on (around linum-on-inhibit-for-modes)
;;   "Stop the load of linum-mode for some major modes."
;;   (unless (member major-mode linum-mode-inhibit-modes-list)
;;     ad-do-it))

;; (ad-activate 'linum-on)

(setq ag-highlight-search t)

;; display “lambda” as “λ”
;;http://ergoemacs.org/emacs/emacs_pretty_lambda.html
(global-prettify-symbols-mode 1)

;;wrap empty space between operators
;;it's not very good
;; (load-file "~/.emacs.d/personal/smart-operator.el")
;; (require 'smart-operator)

;;clean up mode line
(require 'diminish)
(eval-after-load "abbrev"
  '(diminish 'abbrev-mode))
(eval-after-load "magit"
  '(diminish 'magit-auto-revert-mode))
(diminish 'prelude-mode)
(eval-after-load "guru-mode"
  '(diminish 'guru-mode))
(diminish 'whitespace-mode)
(eval-after-load "ws-butler"
  '(diminish 'ws-butler-mode))
(eval-after-load "doxymacs"
  '(diminish 'doxymacs-mode))
(diminish 'company-mode)
(eval-after-load "flyspell"
  '(diminish 'flyspell-mode))

;; Get ride of special buffers
(use-package popwin)
(popwin-mode 1)

;; get ride of trailing-whitespace on some mode
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)
(add-hook 'python-mode-hook 'ws-butler-mode)
(add-hook 'cython-mode-hook 'ws-butler-mode)



(provide 'prelude-appearance)
