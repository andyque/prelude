(prelude-require-packages '(yaml-mode
                            org-octopress
                            ))

(setq octopress-workdir (expand-file-name "~/4gamers.cn/"))

(require 'ido)

(setq octopress-posts (concat octopress-workdir "source/_posts/"))

(defun octopress-rake (command)
  "run rake commands"
  (let ((command-str (format "/bin/bash -l -c 'source $HOME/.rvm/scripts/rvm && rvm use ruby 2.0.0  && cd %s && rake %s'" octopress-workdir command)))
    (shell-command-to-string command-str)))

(defun octopress-qrsync (command)
  (let ((command-str (format "/usr/local/bin/qrsync %s" command )))
    (shell-command-to-string command-str)))


(defun octopress-new (class title)
  (let* ((command-str (format "new_%s[\"%s\"]" class title))
         (command-result (octopress-rake command-str))
         (regexp-str (format "Creating new %s: " class))
         (filename))
    (progn
      (setq filename (concat octopress-workdir "/"
                             (replace-regexp-in-string regexp-str ""
                                                       (car (cdr (reverse (split-string command-result "\n")))))))
      (find-file filename))))

(defun octopress-new-post (title)
  "begin a new post in source/_posts"
  (interactive "MTitle: ")
  (octopress-new "post" title))

(defun octopress-new-page (title)
  "create a new page in source/(filename)/index.markdown"
  (interactive "MTitle: ")
  (octopress-new "page" title))

(defun octopress-generate ()
  "generate jekyll site"
  (interactive)
  (octopress-rake "generate")
  (message "Generate site OK"))

(defun octopress-deploy ()
  "default deploy task"
  (interactive)
  (octopress-rake "deploy")
  ;; (octopress-qrsync "/Users/venmos/.script/venmos-com.json")
  (message "Deploy site OK"))

(defun octopress-gen-deploy ()
  "generate website and deploy"
  (interactive)
  (octopress-rake "gen_deploy")
  ;; (octopress-qrsync "/Users/venmos/.script/venmos-com.json")
  (message "Generate and Deploy OK"))

(defun octopress-posts ()
  "use ack to search  your posts"
  (interactive)
  (octopress-posts (ido-find-file-in-dir octopress-posts)))

(defun octopress-dired ()
  (interactive)
  (octopress-dired (find-file octopress-posts)))

(defun octopress-shell ()
  (interactive)
  (octopress-shell (load-file preview-macs)))

(defun octopress-upimg ()
  (interface)
  (octopress-qrsync "/Users/venmos/.script/venmos-com.json")
  (messenge "Up Img to Qiniu"))

(defun directory-parent (directory)
  (let ((parent (file-name-directory (directory-file-name directory))))
    (if (not (equal directory parent))
        parent)))

(defun jekyll-serve ()
  (interactive)
  (let* ((default-directory
           (if (string-match "_posts/$" default-directory)
               (directory-parent (directory-parent default-directory))
             (directory-parent default-directory)))
         (buffer (if (get-buffer "*jekyll*")
                     (switch-to-buffer "*jekyll*")
                   (ansi-term "/bin/zsh" "jekyll")))
         (proc (get-buffer-process buffer)))
    (term-send-string proc "rake generate && rake preview\n")
    (sit-for 4)
    (browse-url "http://localhost:4000")))

;; ;; http://stackoverflow.com/questions/9435019/how-do-i-source-my-zshrc-within-emacs
;; (defun setup-path-from-zsh ()
;;   (shell-command-to-string "source ~/.zshrc")
;;   (let ((path (shell-command-to-string "echo -n $PATH")))
;;     (setenv "PATH" path)
;;     (setq exec-path
;;           (append
;;            (split-string-and-unquote path ":")
;;            exec-path))))

;; (setup-path-from-zsh)



;use org-mode to publish octopress blog post

(require 'org-octopress)
(setq org-octopress-directory-top       "~/myblog/octopress/source")
(setq org-octopress-directory-posts     "~/myblog/octopress/source/_posts")
(setq org-octopress-directory-org-top   "~/myblog/octopress/source")
(setq org-octopress-directory-org-posts "~/myblog/octopress/source/blog")
(setq org-octopress-setup-file          "~/myblog/octopress/setupfile.org")

(provide 'prelude-blog)
