;;load 3rd party elisps
(add-to-list 'load-path "~/.emacs.d/site-slip/eim")
(add-to-list 'load-path "~/.emacs.d/personal")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(require 'cl-lib)

(setq *macbook-pro-support-enabled* t)
(setq *is-a-mac* (eq system-type 'darwin))
(setq *is-carbon-emacs* (and *is-a-mac* (eq window-system 'mac)))
(setq *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))
(setq *win32* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *linux-x* (and window-system *linux*) )
(setq *xemacs* (featurep 'xemacs) )
(setq *emacs23* (and (not *xemacs*) (or (>= emacs-major-version 23))) )
(setq *emacs24* (and (not *xemacs*) (or (>= emacs-major-version 24))) )
(setq initial-scratch-message nil)

(if *is-a-mac*
    (setq ns-pop-up-frames nil)
    )

(if *win32*
    (progn
      ;;speedup the indexing method on windows
      (setq projectile-indexing-method 'alien)
      ;;modify the windows key to super
      (setq w32-pass-lwindow-to-system nil)
      (setq w32-lwindow-modifier 'super)
      ;;http://www.johndcook.com/blog/emacs_windows/
      ;;delete to trash when delete files in emacs
      (setq delete-by-moving-to-trash t)
      ;;set flyspell applications location
      (setq ispell-program-name "C:/bin/Aspell/bin/aspell.exe")
      ;;http://www.douban.com/group/topic/33000993/
      (set-fontset-font "fontset-default"
                        'gb18030 '("Microsoft YaHei" . "unicode-bmp"))
      ;;when loading emacs from mingw, the follow settings is not needed
      (setq exec-path (add-to-list 'exec-path "C:/Program Files (x86)/Git/bin"))
      (setenv "PATH" (concat "C:\\Program Files (x86)\\Git\\bin;" (getenv "PATH")))
      ;;speedup irony mode
      (setq w32-pipe-read-delay 0)
      )
    )
;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))




;; quick way to access my own config, I now use projectile, so this is not used any more
(defun zilongshanren/config ()
  "open my emacs init.el file"
  (interactive)
    (find-file "~/.emacs.d/init.el"))


;; remove all the duplicated emplies in current buffer
(defun zilongshanren/single-lines-only ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "\\(^\\s-*$\\)\n" nil t)
    (replace-match "\n")
    (forward-char 1)))

;; do command on all marked file in dired mode
(defun zilongshanren/dired-do-command (command)
  "Run COMMAND on marked files. Any files not already open will be opened.
After this command has been run, any buffers it's modified will remain
open and unsaved."
  (interactive "CRun on marked files M-x ")
  (save-window-excursion
    (mapc (lambda (filename)
            (find-file filename)
            (call-interactively command)
            )
          (dired-get-marked-files))))

;; reformat your json file, it requires python
(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))

;; when save a buffer, the directory is not exsits, it will ask you to create the directory
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

(defun qargs()
  "convert a search result buffer to be editable"
  (interactive)
  (wgrep-change-to-wgrep-mode)
  )

(defun zilongshanren/open-line-above()
  "open an empty line above the current line"
  (interactive)
  (save-excursion
    (evil-open-above 1)
    (evil-normal-state)
    ))

(defun zilongshanren/open-line-below()
  "open an empty line below the current line"
  (interactive)
  (save-excursion
    (evil-open-below 1)
    (evil-normal-state))
  )

(defun zilongshanren/dired-up-directory()
  "goto up directory and resue buffer"
  (interactive)
  (find-alternate-file "..")
  )

(defun zilongshanren/evil-quick-replace (beg end )
  (interactive "r")
  (when (evil-visual-state-p)
    (evil-exit-visual-state)
    (let ((selection (regexp-quote (buffer-substring-no-properties beg end))))
      (setq command-string (format "%%s /%s//g" selection))
      (minibuffer-with-setup-hook
          (lambda () (backward-char 2))
      (evil-ex command-string))
      )))

;;; keybinding
;;; grab from https://github.com/cofi/dotfiles/blob/master/emacs.d/config/cofi-util.el
(defun zilong/set-key (map spec cmd)
  "Set in `map' `spec' to `cmd'.
`Map' may be `'global' `'local' or a keymap.
A `spec' can be a `read-kbd-macro'-readable string or a vector."
  (let ((setter-fun (cl-case map
                      (global #'global-set-key)
                      (local  #'local-set-key)
                      (t      (lambda (key def) (define-key map key def)))))
        (key (cl-typecase spec
               (vector spec)
               (string (read-kbd-macro spec))
               (t (error "wrong argument")))))
    (funcall setter-fun key cmd)))

;; define some commands to compile and run cocos2d-x project
;;(setq cocos-repo-dirs
;;     (mapcar
;;       (lambda (dir)
;;         (substring dir 0 -1))
;;       (cl-remove-if-not
;;        (lambda (project)
;;          (unless (file-remote-p project)
;;            (file-directory-p (concat project "/.git/"))))
;;        (projectile-relevant-known-projects))))

(defun zilongshanren/compile ()
  "compile cocos2d-x project"
  (interactive )
  (helm :sources '(build-directory-helm-source))
  )


(defun zilongshanren/run ()
  "run cocos2d-x cpp tests project"
  (interactive)
  (helm :sources '(cocos2d-x-tests-app-helm-source)))

(defun walk-path (dir action)
  "walk DIR executing ACTION with (dir file)"
  (cond ((file-directory-p dir)
         (or (char-equal ?/ (aref dir(1- (length dir))))
             (setq dir (file-name-as-directory dir)))
         (let ((lst (directory-files dir nil nil t))
               fullname file)
           (while lst
             (setq file (car lst))
             (setq lst (cdr lst))
             (cond ((member file '("." "..")))
                   (t
                    (and (funcall action dir file)
                         (setq fullname (concat dir file))
                         (file-directory-p fullname)
                         (unless (string-match-p ".app" fullname)
                           (walk-path fullname action))
                           )
                         )))))
        (t
         (funcall action
                  (file-name-directory dir)
                  (file-name-nondirectory dir)))))



(defmacro value-bound-lambda (args symbols &rest body)
  "Returns a lambda expression with ARGS, where each symbol in SYMBOLS is
available for use and is bound to it's value at creation.
Symbols needs to be a list of variables or functions available globally."
  (declare (indent defun))
  (let ((vars (remove-if-not 'boundp symbols))
        (funcs (remove-if-not 'functionp symbols)))
    `(lambda ,args
       (let ,(mapcar (lambda (sym) (list sym (symbol-value sym))) vars)
         ,@(mapcar (lambda (sym) `(fset ',sym ,(symbol-function sym))) funcs)
         ,@body))))


(require 'vc)

(setq cocos2d-x-all-running-test-names nil)

(defun zilongshanren/find-all-exes ()
  "get all test app folder name"
  (interactive)
    (walk-path (concat (vc-root-dir) "mac-build/tests")
               (lambda(dir file)
                 (if (string-match-p ".app" file)
                     (add-to-list 'cocos2d-x-all-running-test-names  (substring file 0 (- (length file) 4)))
                   t
                   )))
    cocos2d-x-all-running-test-names
    )


(setq cocos2d-x-tests-app-helm-source
      '((name . "Run cocos2d-x tests:")
        (candidates . zilongshanren/find-all-exes)
        (action . (lambda (candidate)
                    (shell-command-to-string  (concat (vc-root-dir)
                                                                  (format "mac-build/tests/%s/%s.app/Contents/MacOS/%s" candidate candidate candidate)))
                    ))))

(defun build-cocos2d-x-games (command-str)
  "run command-str in a dedicated ansi-term buffer"
  (interactive)
  (let* ((buffer (if (get-buffer "*compile*")
                     (switch-to-buffer-other-window  "*compile*" nil)
                   (ansi-term "/bin/zsh" "compile")))
         (proc (get-buffer-process ())))
    (term-send-string
     proc command-str)
  ))


(setq build-directory-helm-source
      '((name . "Build directories")
        (candidates . cocos-repo-dirs)
        (action . (lambda (candidate)
                    (let* ((cmake-working-dir (concat candidate "/mac-build")))
                      (progn
                        (unless (file-exists-p cmake-working-dir)
                          (make-directory cmake-working-dir))
                        (zilongshanren/find-all-exes)
                        ;;generate cmake project aynsc and compile the project
                        (if (file-exists-p (concat cmake-working-dir "/CMakeCache.txt"))
                            (build-cocos2d-x-games (format "cd %s &&  make -j4\n" cmake-working-dir))
                          (build-cocos2d-x-games (format "cd %s && cmake .. \n" cmake-working-dir))
                          )
                    ))))))

(defun jcs-retrieve-url()
  "Retrieve URL from current Safari page"
  (interactive)
  (let ((result (shell-command-to-string
                 "osascript -e 'tell application \"Safari\" to return URL of document 1'")))
    (format "%s" result))
  )


;; get current safari tab link
(defun jcs-get-link (link)
  "Retrieve URL from current Safari page and prompt for description.
Insert an Org link at point."
  (interactive "sLink Description: ")
  (let ((result (shell-command-to-string
                 "osascript -e 'tell application \"Safari\" to return URL of document 1'")))
    (insert (format "[[%s][%s]]" (org-trim result) link))))

(defun zilongshanren/insert-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
      (let ((result (do-applescript
                     (concat
                      "set frontmostApplication to path to frontmost application\n"
                      "tell application \"Google Chrome\"\n"
                      "	set theUrl to get URL of active tab of first window\n"
                      "	set theResult to (get theUrl) \n"
                      "end tell\n"
                      "activate application (frontmostApplication as text)\n"
                      "set links to {}\n"
                      "copy theResult to the end of links\n"
                      "return links as string\n"))))
        (insert result)))

(defun zilongshanren/retrieve-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
      (let ((result (do-applescript
                     (concat
                      "set frontmostApplication to path to frontmost application\n"
                      "tell application \"Google Chrome\"\n"
                      "	set theUrl to get URL of active tab of first window\n"
                      "	set theResult to (get theUrl) \n"
                      "end tell\n"
                      "activate application (frontmostApplication as text)\n"
                      "set links to {}\n"
                      "copy theResult to the end of links\n"
                      "return links as string\n"))))
        (format "%s" result)))

(defun zilongshanren/org-archive-done-tasks ()
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))
