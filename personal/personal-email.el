;;; package --- This package is mainly for handling my dialy email workflow in Emacs
;;; Code:
;;; Commentary:

;; add the source shipped with mu to load-path
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/mu4e"))

;; make sure emacs finds applications in /usr/local/bin
(setq exec-path (cons "/usr/local/bin" exec-path))

;; require mu4e
(require 'mu4e)

(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

;; tell mu4e where my Maildir is
;; mail dir is very important, otherwise the email won't be update properly
(setq mu4e-maildir "/Users/guanghui/.email")
;; tell mu4e how to sync email
(setq mu4e-get-mail-command "/usr/local/bin/mbsync -a")

;; (defadvice mu4e-update-mail-and-index (after my-mu4e-update-hook activate compile)
;;   "Run mu index after update email."
;;   (shell-command-to-string "mu index  --maildir=~/.email/")
;;   )

;; (ad-activate 'mu4e-update-mail-and-index)

;; tell mu4e to use w3m for html rendering
(setq mu4e-html2text-command "/usr/local/bin/w3m -T text/html")
(setq mu4e-sent-messages-behavior 'sent)

(setq mu4e-maildir-shortcuts
'( ("/INBOX"               . ?i)
   ("/[Gmail].Sent Mail"   . ?s)
   ("/[Gmail].Starred"     . ?r)
   ("/[Gmail].Trash"       . ?t)
   ("/[Gmail].All Mail"    . ?a)))

(setq mu4e-update-interval (* 10 60))

;; something about ourselves
(setq
 user-mail-address "guanghui8827@gmail.com"
 user-full-name  "Guanghui Qu"
 mu4e-compose-signature "Thank you!")

;; show images
(setq mu4e-show-images t)



;; spell check
(add-hook 'mu4e-compose-mode-hook
          (defun my-do-compose-stuff ()
            "My settings for message composition."
            (set-fill-column 72)
            (flyspell-mode)))

;; use msmtp
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/local/bin/msmtp")
;; tell msmtp to choose the SMTP server according to the from field in the outgoing email
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil 't)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; Confirmation before sending
(add-hook 'message-send-hook
          (lambda ()
            (unless (yes-or-no-p "Sure you want to send this?")
              (signal 'quit nil))))

;; Skipping duplicates
(setq mu4e-headers-skip-duplicates t)

 ;;; message view action
(defun mu4e-msgv-action-view-in-browser (msg)
  "View the body of the message in a web browser."
  (interactive)
  (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
        (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
    (unless html (error "No html part for this message"))
    (with-temp-file tmpfile
      (insert
       "<html>"
       "<head><meta http-equiv=\"content-type\""
       "content=\"text/html;charset=UTF-8\">"
       html))
    (browse-url (concat "file://" tmpfile))))

(add-to-list 'mu4e-view-actions
             '("View in browser" . mu4e-msgv-action-view-in-browser) t)

;; We only need one way to do with email

;; (require 'gnus)
;; (require 'nnir)

;; ;; ask encyption password once
;; (setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; (setq smtpmail-auth-credentials "~/.authinfo.gpg")

;; ;;@see http://gnus.org/manual/gnus_397.html
;; (add-to-list 'gnus-secondary-select-methods
;;              '(nnimap "qq"
;;                       (nnimap-address "imap.qq.com")
;;                       (nnimap-server-port 993)
;;                       (nnimap-stream ssl)
;;                       (nnir-search-engine imap)
;;                       (nnimap-authinfo-file "~/.authinfo.gpg")
;;                       ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
;;                       ;; press 'E' to expire email
;;                       ;; (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
;;                       (nnmail-expiry-wait 90)))

;; (add-to-list 'gnus-secondary-select-methods
;;              '(nnimap "126"
;;                       (nnimap-address "imap.126.com")
;;                       (nnimap-server-port 993)
;;                       (nnimap-stream ssl)
;;                       (nnir-search-engine imap)
;;                       (nnimap-authinfo-file "~/.authinfo.gpg")
;;                       ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
;;                       ;; press 'E' to expire email
;;                       ;; (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
;;                       (nnmail-expiry-wait 90)))

;; (setq gnus-thread-sort-functions
;;       '((not gnus-thread-sort-by-date)
;;         (not gnus-thread-sort-by-number)))

;; ; NO 'passive
;; (setq gnus-use-cache t)

;; ;; BBDB: Address list
;; ;; (add-to-list 'load-path "/where/you/place/bbdb/")
;; ;; (require 'bbdb)

;; ;; (bbdb-initialize 'message 'gnus 'sendmail)
;; ;; (setq bbdb-file "~/.bbdb") ;; OPTIONAL, because I'm sharing my ~/.emacs.d
;; ;; (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
;; ;; (setq bbdb/mail-auto-create-p t
;; ;;       bbdb/news-auto-create-p t)

;; ;; auto-complete emacs address using bbdb's own UI
;; ;; (add-hook 'message-mode-hook
;; ;;           '(lambda ()
;; ;;              (flyspell-mode t)
;; ;;              (local-set-key "<TAB>" 'bbdb-complete-name)))

;; ;; Fetch only part of the article if we can.  I saw this in someone
;; ;; else's .gnus
;; (setq gnus-read-active-file 'some)

;; ;; Tree view for groups.  I like the organisational feel this has.
;; (add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; ;; Threads!  I hate reading un-threaded email -- especially mailing
;; ;; lists.  This helps a ton!
;; (setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)

;; ;; Also, I prefer to see only the top level message.  If a message has
;; ;; several replies or is part of a thread, only show the first
;; ;; message.  'gnus-thread-ignore-subject' will ignore the subject and
;; ;; look at 'In-Reply-To:' and 'References:' headers.
;; (setq gnus-thread-hide-subtree t)
;; (setq gnus-thread-ignore-subject t)

;; ;; Personal Information
;; (setq user-full-name "Guanghui Qu"
;;       user-mail-address "254041321@qq.com")

;; ;; You need install the command line brower 'w3m' and Emacs plugin 'w3m'
;; (setq mm-text-html-renderer 'w3m)

;; ;; (setq message-send-mail-function 'smtpmail-send-it
;; ;;       smtpmail-starttls-credentials '(("smtp.qq.com" 587 nil nil))
;; ;;       smtpmail-auth-credentials "~/.authinfo.gpg"
;; ;;       smtpmail-default-smtp-server "smtp.qq.com"
;; ;;       smtpmail-smtp-server "smtp.qq.com"
;; ;;       smtpmail-smtp-service 587
;; ;;       smtpmail-local-domain "homepc")
;; ;; http://www.gnu.org/software/emacs/manual/html_node/gnus/_005b9_002e2_005d.html
;; (setq gnus-use-correct-string-widths nil)

;; (require 'smtpmail)
;; (setq smtpmail-smtp-server "mail.qq.com"
;;       send-mail-function 'smtpmail-send-it
;;       smtpmail-auth-credentials "~/.authinfo.gpg")

;; (defun my-gnus-group-list-subscribed-groups ()
;;   "List all subscribed groups with or without un-read messages"
;;   (interactive)
;;   (gnus-group-list-all-groups 5)
;;   )


;; (define-key gnus-group-mode-map
;;   ;; list all the subscribed groups even they contain zero un-read messages
;;   (kbd "o") 'my-gnus-group-list-subscribed-groups)

(provide 'prelude-email)
;;; prelude-email.el ends here
