(require 'gnus)
(require 'nnir)

;; ask encyption password once
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

(setq smtpmail-auth-credentials "~/.authinfo.gpg")

;;@see http://gnus.org/manual/gnus_397.html
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "qq"
                      (nnimap-address "imap.qq.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      (nnimap-authinfo-file "~/.authinfo.gpg")
                      ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
                      ;; press 'E' to expire email
                      ;; (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
                      (nnmail-expiry-wait 90)))

(add-to-list 'gnus-secondary-select-methods
             '(nnimap "126"
                      (nnimap-address "imap.126.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      (nnimap-authinfo-file "~/.authinfo.gpg")
                      ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
                      ;; press 'E' to expire email
                      ;; (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
                      (nnmail-expiry-wait 90)))

(setq gnus-thread-sort-functions
      '((not gnus-thread-sort-by-date)
        (not gnus-thread-sort-by-number)))

; NO 'passive
(setq gnus-use-cache t)

;; BBDB: Address list
;; (add-to-list 'load-path "/where/you/place/bbdb/")
;; (require 'bbdb)

;; (bbdb-initialize 'message 'gnus 'sendmail)
;; (setq bbdb-file "~/.bbdb") ;; OPTIONAL, because I'm sharing my ~/.emacs.d
;; (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
;; (setq bbdb/mail-auto-create-p t
;;       bbdb/news-auto-create-p t)

;; auto-complete emacs address using bbdb's own UI
;; (add-hook 'message-mode-hook
;;           '(lambda ()
;;              (flyspell-mode t)
;;              (local-set-key "<TAB>" 'bbdb-complete-name)))

;; Fetch only part of the article if we can.  I saw this in someone
;; else's .gnus
(setq gnus-read-active-file 'some)

;; Tree view for groups.  I like the organisational feel this has.
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Threads!  I hate reading un-threaded email -- especially mailing
;; lists.  This helps a ton!
(setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)

;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first
;; message.  'gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Personal Information
(setq user-full-name "Guanghui Qu"
      user-mail-address "254041321@qq.com")

;; You need install the command line brower 'w3m' and Emacs plugin 'w3m'
(setq mm-text-html-renderer 'w3m)

;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-starttls-credentials '(("smtp.qq.com" 587 nil nil))
;;       smtpmail-auth-credentials "~/.authinfo.gpg"
;;       smtpmail-default-smtp-server "smtp.qq.com"
;;       smtpmail-smtp-server "smtp.qq.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-local-domain "homepc")
;; http://www.gnu.org/software/emacs/manual/html_node/gnus/_005b9_002e2_005d.html
(setq gnus-use-correct-string-widths nil)

(require 'smtpmail)
(setq smtpmail-smtp-server "mail.qq.com"
      send-mail-function 'smtpmail-send-it
      smtpmail-auth-credentials "~/.authinfo.gpg")

(defun my-gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages"
  (interactive)
  (gnus-group-list-all-groups 5)
  )


(define-key gnus-group-mode-map 
  ;; list all the subscribed groups even they contain zero un-read messages
  (kbd "o") 'my-gnus-group-list-subscribed-groups)

(provide 'prelude-gnus)
