
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


(provide 'prelude-feed)
