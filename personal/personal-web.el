(prelude-require-packages '(web-mode
                            skewer-mode
                            impatient-mode))
(defun open-in-browser()
  (interactive)
  (let ((filename (buffer-file-name)))
    (browse-url (concat "file://" filename))))


(defun my-web-mode-hook()
  "my web mode hook for HTML REPL"
  (interactive)
  (impatient-mode)
  (httpd-start))

(add-hook 'web-mode-hook 'my-web-mode-hook)
