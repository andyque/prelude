;;; Code:
(prelude-require-packages '(find-by-pinyin-dired))

(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message
       "Size of all marked files: %s"
       (progn
         (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
         (match-string 1))))))

(define-key dired-mode-map (kbd "z") 'dired-get-size)
(define-key dired-mode-map (kbd "C-c C-e") 'dired-toggle-read-only)

;; add `flet'
(require 'cl)

(defadvice save-buffers-kill-emacs
    (around no-query-kill-emacs activate)
  "Prevent \"Active processes exist\" query on exit."
  (cl-flet ((process-list ())) ad-do-it))

(require 'dired-x)

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "open")
        ("\\.\\(?:djvu\\|eps\\)\\'" "open")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "open")
        ("\\.\\(?:xcf\\)\\'" "open")
        ("\\.csv\\'" "open")
        ("\\.tex\\'" "open")
        ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "open")
        ("\\.\\(?:mp3\\|flac\\)\\'" "open")
        ("\\.html?\\'" "open")
        ("\\.md\\'" "open")))


(require 'dired-aux)

(defvar dired-filelist-cmd
  '(("vlc" "-L")))

(defun dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files
                 t current-prefix-arg)))
     (list
      (dired-read-shell-command "& on %s: "
                                current-prefix-arg files)
      files)))
  (let (list-switch)
    (start-process
     cmd nil shell-file-name
     shell-command-switch
     (format
      "nohup 1>/dev/null 2>/dev/null %s \"%s\""
      (if (and (> (length file-list) 1)
               (setq list-switch
                     (cadr (assoc cmd dired-filelist-cmd))))
          (format "%s %s" cmd list-switch)
        cmd)
      (mapconcat #'expand-file-name file-list "\" \"")))))

(define-key dired-mode-map "r" 'dired-start-process)
(define-key dired-mode-map "E" 'dired-toggle-read-only)
(define-key dired-mode-map "p" 'find-by-pinyin-dired)

(define-key dired-mode-map (kbd "`") 'dired-open-term)

(defun dired-open-term ()
  "Open an `ansi-term' that corresponds to current directory."
  (interactive)
  (let* ((current-dir (dired-current-directory))
         (buffer (if (get-buffer "*zshell*")
                     (switch-to-buffer "*zshell*")
                   (ansi-term "/bin/zsh" "zshell")))
         (proc (get-buffer-process buffer)))
    (term-send-string
     proc
     (if (file-remote-p current-dir)
         (let ((v (tramp-dissect-file-name current-dir t)))
           (format "ssh %s@%s\n"
                   (aref v 1) (aref v 2)))
       (format "cd '%s'\n" current-dir)))))

(eval-after-load 'dired-mode
  (progn
    (define-key dired-mode-map (kbd "C-k") 'zilongshanren/dired-up-directory)))

(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))


;; for running long run ansi-term
(defun named-term (name)
  (interactive "sName: ")
  (ansi-term "/bin/zsh" name))

;; find Chinese filename by pingyin
(require 'find-by-pinyin-dired)

(defun dired-copy-file-here (file)
  (interactive "fCopy file: ")
  (copy-file file default-directory))
(eval-after-load "dired"
  '(define-key dired-mode-map "c" 'dired-copy-file-here))

;; async dired command
;; (when (require 'dired-aux)
;;   (require 'dired-async))
(define-key dired-mode-map (kbd "<mouse-2>") 'dired-find-alternate-file)
(provide 'personal-dired)
;;; personal-dired.el ends here
