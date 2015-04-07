;; Support for the http://kapeli.com/dash documentation browser
(prelude-require-packages '(weibo
                            youdao-dictionary
                            helm-github-stars
                            elfeed
                            restclient
                            sx
                            ))

(defun sanityinc/dash-installed-p ()
  "Return t if Dash is installed on this machine, or nil otherwise."
  (let ((lsregister "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"))
    (and (file-executable-p lsregister)
         (not (string-equal
               ""
               (shell-command-to-string
                (concat lsregister " -dump|grep com.kapeli.dash")))))))
(require 'popwin)
(push "*Youdao Dictionary*" popwin:special-display-config)


(when (and *is-a-mac* (not (package-installed-p 'dash-at-point)))
  (message "Checking whether Dash is installed")
  (when (sanityinc/dash-installed-p)
    (prelude-require-package 'dash-at-point)))

(define-key prelude-mode-map (kbd "C-c d") 'dash-at-point)
;; (global-set-key (kbd "C-c d") 'dash-at-point)
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point+)

;; Enable Cache
(setq url-automatic-caching t)

;; Set file path for saving search history
(setq youdao-dictionary-search-history-file "~/.emacs.d/savefile/.youdao")

;; Enable Chinese word segmentation support (支持中文分词)
(setq youdao-dictionary-use-chinese-word-segmentation t)

;; Settings for Weibo
(require 'weibo)
(setq weibo-consumer-key "143587575"
      weibo-consumer-secret "920a1a16367e8d224f8227b581413524")

;; helm-github-stars
;; https://github.com/Sliim/helm-github-stars
(require 'helm-github-stars)
(setq helm-github-stars-username "andyque")
(setq helm-github-stars-cache-file "~/.emacs.d/savefile/hgs-cache")


;;define hydra for tools
(defhydra hydra-tools (:color red)
  "
 Youdao: _y_
 Dash: _d_
  Weibo: _w_
"
  ("y" youdao-dictionary-search-at-point nil :exit t)
  ("d" dash-at-point nil :exit t)
  ("w" weibo-timeline nil :exit t)
  ("q"  nil "quit"))

;; (evil-leader/set-key "t" 'hydra-tools/body)
(global-set-key (kbd "C-c w") 'weibo-timeline)


(defun hotspots ()
  "helm interface to my hotspots, which includes my locations,
org-files and bookmarks"
  (interactive)
  (helm :sources `(((name . "Mail and News")
                    (candidates . (("Calendar" . (lambda ()  (browse-url "https://www.google.com/calendar/render")))
                                   ("Gmail" . (lambda() (mu4e)))
                                   ("RSS" . elfeed)
                                   ("Github" . (lambda() (helm-github-stars)))
                                   ("Spell" . (lambda() (if (and (boundp 'flyspell-mode) flyspell-mode)
                                                       (turn-off-flyspell)
                                                     (turn-on-flyspell))))
                                   ("Writing" . (lambda()(olivetti-mode)))
                                   ("weibo" . (lambda()(weibo-timeline)))
                                   ("Agenda" . (lambda () (org-agenda "" "a")))
                                   ("sicp" . (lambda() (w3m-browse-url "http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-4.html#%_toc_start")))
                                   ))

                    (action . (("Open" . (lambda (x) (funcall x))))))
                   ((name . "My Locations")
                    (candidates . ((".emacs.d" . "~/.emacs.d/init.el" )
                                   ("blog" . "~/4gamers.cn/")
                                   ("notes" . "~/org-notes/notes.org")
                                   ))
                    (action . (("Open" . (lambda (x) (find-file x))))))

                   helm-source-recentf
                   helm-source-bookmarks
                   helm-source-bookmark-set)))

(global-set-key (kbd "<f1>") 'hotspots)

;; enable EasyPG for encrypting
;; (require 'epa-file)
;; (epa-file-enable)

;; stackoverflow settings
(global-set-key (kbd "C-c l") 'zilongshanren/insert-chrome-current-tab-url)

;; reset client mode
(use-package restclient
  :commands (restclient-mode)
  :defer t
  :config
  (add-to-list 'company-backends 'company-restclient)
  )

(provide 'prelude-tools)
