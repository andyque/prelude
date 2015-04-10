;;; package --- tool for interactive with external programs and web service
;;; Commentary:
;;; Github repo:https://github.com/abo-abo/hydra
;;; Code:
(prelude-require-packages '(weibo
                            youdao-dictionary
                            helm-github-stars
                            elfeed
                            restclient
                            sx
                            helm-flyspell
                            ))

(global-set-key (kbd "C-x w") 'elfeed)

(setq elfeed-feeds
      '("http://nullprogram.com/feed/"
        "http://z.caudate.me/rss/"
        "http://sachachua.com/blog/feed/"
        "http://irreal.org/blog/?feed=rss2"
        "http://feeds.feedburner.com/LostInTheTriangles"
        "http://blog.codingnow.com/atom.xml"
        "http://tonybai.com/feed/"
        "http://planet.emacsen.org/atom.xml"
        "http://feeds.feedburner.com/emacsblog"
        "http://blog.binchen.org/rss.xml"
        "http://oremacs.com/atom.xml"
        "http://www.lispcast.com/feed"
        "http://blog.gemserk.com/feed/"
        "http://www.masteringemacs.org/feed/"
        "http://t-machine.org/index.php/feed/"
        "http://zh.lucida.me/atom.xml"
        "http://gameenginebook.blogspot.com/feeds/posts/default"
        "http://feeds.feedburner.com/ruanyifeng"
        "http://coolshell.cn/feed"
        "http://blog.devtang.com/atom.xml"
        "http://emacsnyc.org/atom.xml"
        "http://puntoblogspot.blogspot.com/feeds/2507074905876002529/comments/default"
        ))

(defun elfeed-mark-all-as-read ()
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread))

(use-package elfeed
  :defer t
  :config
  (define-key elfeed-search-mode-map (kbd "R") 'elfeed-mark-all-as-read)
  )

(defadvice elfeed-show-yank (after elfeed-show-yank-to-kill-ring activate compile)
  "Insert the yanked text from x-selection to kill ring"
  (kill-new (x-get-selection)))

(ad-activate 'elfeed-show-yank)

;; Support for the http://kapeli.com/dash documentation browser
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


;; enable EasyPG for encrypting
;; (require 'epa-file)
;; (epa-file-enable)
;; reset client mode

(use-package restclient
  :commands (restclient-mode)
  :defer t
  :config
  (add-to-list 'company-backends 'company-restclient)
  )

;;flyspell settings
(require 'flyspell)
(setq prelude-flyspell nil)
(add-hook 'org-mode-hook 'turn-on-flyspell)
(add-hook 'markdown-mode-hook 'turn-on-flyspell)

;; you can also use "M-x ispell-word" or hotkey "M-$". It pop up a multiple choice
;; @see http://frequal.com/Perspectives/EmacsTip03-FlyspellAutoCorrectWord.html
;; (global-unset-key (kbd "C-c s"))
(define-key prelude-mode-map (kbd "C-c s") nil)
(require 'helm-flyspell)
(global-set-key (kbd "C-c s") 'helm-flyspell-correct)



(provide 'personal-tools)
;;; personal-tools ends here
