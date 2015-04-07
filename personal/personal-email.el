;;; package --- This package is mainly for handling my dialy email workflow in Emacs
;;; Code:
;;; Commentary:

;; add the source shipped with mu to load-path
(add-to-list 'load-path (expand-file-name "/usr/local/Cellar/mu/0.9.11/share/emacs/site-lisp/mu4e"))

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


(provide 'prelude-email)
;;; prelude-email.el ends here
