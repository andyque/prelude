(prelude-require-packages '(w3m))
;;change default browser for 'browse-url'  to w3m
;; (setq browse-url-browser-function 'w3m-goto-url-new-session)
 
;;change w3m user-agent to android
(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")
 
;;quick access hacker news
(defun hn ()
  (interactive)
  (w3m-browse-url "http://news.ycombinator.com"))
 
;;quick access reddit
(defun reddit (reddit)
  "Opens the REDDIT in w3m-new-session"
  (interactive (list
                (read-string "Enter the reddit (default: emacs): " nil nil "emacs" nil)))
  (w3m-browse-url (format "http://m.reddit.com/r/%s" reddit))
  )
 
;;i need this often
(defun wikipedia-search (search-term)
  "Search for SEARCH-TERM on wikipedia"
  (interactive
   (let ((term (if mark-active
                   (buffer-substring (region-beginning) (region-end))
                 (word-at-point))))
     (list
      (read-string
       (format "Wikipedia (%s):" term) nil nil term)))
   )
  (w3m-browse-url
   (concat
    "http://en.m.wikipedia.org/w/index.php?search="
    search-term
    ))
  )
 
;;when I want to enter the web address all by hand
(defun w3m-open-site (site)
  "Opens site in new w3m session with 'http://' appended"
  (interactive
   (list (read-string "Enter website address(default: w3m-home):" nil nil w3m-home-page nil )))
  (w3m-goto-url-new-session
   (concat "http://" site)))

(add-hook 'w3m-mode-hook 'w3m-lnum-mode)

(defun browse-url-with-w3m (event)
  (interactive "e")
  (let ((browse-url-browser-function 'w3m-browse-url))
    (browse-url-at-mouse event)))

(defun browse-url-with-default-browser (event)
  (interactive "e")
  (let ((browse-url-browser-function 'browse-url-default-browser))
    (browse-url-at-mouse event)))

;; (global-set-key (kbd "<mouse-1>") 'browse-url-with-w3m)
(global-set-key (kbd "<C-down-mouse-1>") 'browse-url-with-w3m)


(provide 'prelude-w3m)
