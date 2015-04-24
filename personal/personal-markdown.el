(prelude-require-packages '(org-octopress
                            flyspell
                            markdown-mode
                            ))
(add-hook 'info-mode-hook 'iimage-mode)

;;add ,ii to turn-on-iimage-mode,  keymapping defined in init-evil-keymappings.el

;; If the iamge path is changes, we should add more string path to the list
(setq iimage-mode-image-search-path '(list "." "~/myblog/octopress/source/"))

;; for octopress
;; (add-to-list 'iimage-mode-image-regex-alist ; match: {% img xxx %}
;;        (cons (concat "{% img /?\\("
;;              iimage-mode-image-filename-regex
;;              "\\) %}") 1))
;; add more regex type to display inline images
;; (add-to-list 'iimage-mode-image-regex-alist ; match: {% img right xxx 300 300 %}
;;        (cons (concat "{% img right /?\\("
;;              iimage-mode-image-filename-regex
;;              "\\) 300 300 %}") 1))
;; (add-to-list 'iimage-mode-image-regex-alist ; match: ![xxx](/xxx)
;;        (cons (concat "!\\[.*?\\](/\\("
;;              iimage-mode-image-filename-regex
;;              "\\))") 1))

;; (add-hook 'markdown-mode-hook 'flyspell-mode)
;;; Commentary:

;;; Commentary:

;; Just rewritten some functions of impatient mode
;; You should install `markdown', which is used to convert markdown file to html
;; For Mac user: brew install markdown.
;; Usage :
;; (imp-markdown-current-buffer) ;; start
;; (imp-normal) ;; back to normal impatient-mode
;; Hope you like it!

(defun imp-markdown (buffer)
  (interactive)
  (httpd-start)
  (unless (and (boundp 'impatient-mode) impatient-mode)
    (impatient-mode))
  (unless (fboundp 'imp--send-state-old)
    (defalias 'imp--send-state-old (symbol-function 'imp--send-state)))
  (defun imp--send-state (proc)
    (let ((id (number-to-string imp-last-state))
          (buffer (current-buffer)))
      (with-temp-buffer
        (insert id " ")
        (insert (markdown-to-html buffer))
        (httpd-send-header proc "text/plain" 200 :Cache-Control "no-cache"))))
  (imp-visit-buffer)
  'imp--send-state-old)

;;;###autoload
(defun imp-normal ()
  (interactive)
  (defalias 'imp--send-state 'imp--send-state-old))

;;;###autoload
(defun imp-markdown-current-buffer ()
  (interactive)
  (imp-markdown (current-buffer)))

(defun markdown-to-html (buffer)
  (let ((md-file "/tmp/this-is-a-nonsense-file.md"))
    (unwind-protect
        (progn
          (with-temp-file md-file
            (kill-region (point-min) (point-max))
            (insert (with-current-buffer buffer (buffer-string))))
          (shell-command-to-string
           (format "markdown %s" md-file)))
      (delete-file md-file))))

(require 'markdown-mode)

;; call-process will block emacs
;; (defun zilongshanren/markdown-to-html ()
;;   (interactive)
;;   (call-process "/usr/local/bin/grip" nil nil nil
;;                 "--gfm" "--export"
;;                 (buffer-file-name)
;;                 "/tmp/grip.html"))

(defun zilongshanren/markdown-to-html ()
  (interactive)
  (start-process "grip" "*gfm-to-html*" "grip" (buffer-file-name)

                 )
  (browse-url (format  "http://localhost:5000/%s.md" (file-name-base))))
(define-key gfm-mode-map (kbd "s-h") 'zilongshanren/markdown-to-html)


(provide 'prelude-markdown)
