;;; Code:
(prelude-require-packages '(org-octopress
                            org-pomodoro
                            ox-reveal
                            worf
                            ))

(add-to-list 'org-modules "org-habit")
(require 'org-mac-link)

(setq org-agenda-inhibit-startup t) ;; ~50x speedup
(setq org-agenda-use-tag-inheritance nil) ;; 3-4x speedup
(setq org-agenda-window-setup 'current-window)

(add-to-list 'auto-mode-alist '("\\.org\\’" . org-mode))

(define-key prelude-mode-map (kbd "C-c a") nil)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(setq org-log-done t)

(defun prelude-org-mode-defaults ()
  (let ((oldmap (cdr (assoc 'prelude-mode minor-mode-map-alist)))
        (newmap (make-sparse-keymap)))
    (set-keymap-parent newmap oldmap)
    (define-key newmap (kbd "C-c +") nil)
    (define-key newmap (kbd "C-c -") nil)
    (make-local-variable 'minor-mode-overriding-map-alist)
    (push `(prelude-mode . ,newmap) minor-mode-overriding-map-alist))
)

(setq prelude-org-mode-hook 'prelude-org-mode-defaults)

(add-hook 'org-mode-hook (lambda () (run-hooks 'prelude-org-mode-hook)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-custom-commands nil)
 '(org-agenda-files (quote ("~/org-notes/gtd.org"
                            "~/org-notes/emacs.org"
                            "~/org-notes/cocos2d-x.org"
                            "~/org-notes/notes.org"
                            "~/org-notes/learning.org"
                            "~/org-notes/vim.org"
                            "~/org-notes/journal.org"
                            )))
 '(org-agenda-ndays 1)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-skip-deadline-prewarning-if-scheduled t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-reverse-note-order t))

;; (define-key global-map "\C-cl" 'org-insert-link)

(setq org-mobile-directory "~/org-notes/org")

(require 'org-compat)
(require 'org)
(require 'org-install)
;; {{ export org-mode in Chinese into PDF
;; @see http://freizl.github.io/posts/tech/2012-04-06-export-orgmode-file-in-Chinese.html
;; and you need install texlive-xetex on different platforms
;; To install texlive-xetex:
;;    `sudo USE="cjk" emerge texlive-xetex` on Gentoo Linux
(setq org-latex-to-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
	"xelatex -interaction nonstopmode -output-directory %o %f"
	"xelatex -interaction nonstopmode -output-directory %o %f"))
;; }}
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
	      (sequence "WAITING(w@/!)" "SOMEDAY(S)"  "|" "CANCELLED(c@/!)" "MEETING(m)" "PHONE(p)"))))
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org clock
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;;set my person org files seperated and stored in a paticular place
;; (setq org-agenda-files (list "~/org-notes/gtd.org"))

;; config for org-mode html5 presentation
;;require org 8.0+
(setq org-reveal-root "file:///Users/guanghui/.emacs.d/reveal-js")
(require 'ox-reveal)'


					;some other configs
(defun gtd ()
  "open the GTD files of my own"
  (interactive)
  (find-file "~/org-notes/gtd.org"))

(if *is-a-mac*
    (setq browse-url-browser-function 'browse-url-default-macosx-browser)
    )

;;config for org-capture
(setq org-default-notes-file "~/org-notes/gtd.org")

(define-key prelude-mode-map (kbd "C-c r") nil)
(define-key global-map (kbd "C-c r") 'org-capture)

;; the %i would copy the selected text into the template
;;http://www.howardism.org/Technical/Emacs/journaling-org.html
;;add multi-file journal
(setq org-capture-templates
      '(("n" "notes" entry (file+headline "~/org-notes/notes.org" "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("e" "emacs" entry (file+headline "~/org-notes/emacs.org" "Quick notes")
         "* %? \n %(zilongshanren/retrieve-chrome-current-tab-url)\n %U\n "
         :empty-lines 1)
        ("t" "Todo" entry (file+headline "~/org-notes/gtd.org" "Daily Tasks")
	 "* TODO %?\n  %i\n"
         :empty-lines 1)
        ("w" "Todo" entry (file+headline "~/org-notes/gtd.org" "Weekly Tasks")
	 "* TODO %?\n  %i\n"
         :empty-lines 1)
        ("m" "Todo" entry (file+headline "~/org-notes/gtd.org" "Monthly Tasks")
	 "* TODO %?\n  %i\n"
         :empty-lines 1)
        ("j" "Journal Entry"
         entry (file+datetree "~/org-notes/journal.org")
         "* %?"
         :empty-lines 1)
	))


;; used by org-clock-sum-today-by-tags
(defun filter-by-tags ()
  (let ((head-tags (org-get-tags-at)))
    (member current-tag head-tags)))

(defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
  (interactive "P")
  (let* ((timerange-numeric-value (prefix-numeric-value timerange))
         (files (org-add-archive-files (org-agenda-files)))
         (include-tags '("WORK" "ENGLISH" "DREAM" "writing" "DREAM"
                         "LIFE" "PROJECT" "OTHER"))
         (tags-time-alist (mapcar (lambda (tag) `(,tag . 0)) include-tags))
         (output-string "")
         (tstart (or tstart
                     (and timerange (equal timerange-numeric-value 4) (- (org-time-today) 86400))
                     (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "Start Date/Time:"))
                     (org-time-today)))
         (tend (or tend
                   (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "End Date/Time:"))
                   (+ tstart 86400)))
         h m file item prompt donesomething)
    (while (setq file (pop files))
      (setq org-agenda-buffer (if (file-exists-p file)
                                  (org-get-agenda-file-buffer file)
                                (error "No such file %s" file)))
      (with-current-buffer org-agenda-buffer
        (dolist (current-tag include-tags)
          (org-clock-sum tstart tend 'filter-by-tags)
          (setcdr (assoc current-tag tags-time-alist)
                  (+ org-clock-file-total-minutes (cdr (assoc current-tag tags-time-alist)))))))
    (while (setq item (pop tags-time-alist))
      (unless (equal (cdr item) 0)
        (setq donesomething t)
        (setq h (/ (cdr item) 60)
              m (- (cdr item) (* 60 h)))
        (setq output-string (concat output-string (format "[-%s-] %.2d:%.2d\n" (car item) h m)))))
    (unless donesomething
      (setq output-string (concat output-string "[-Nothing-] Done nothing!!!\n")))
    (unless noinsert
      (insert output-string))
    output-string))

;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(setq pomodoro-break-time 2)
(setq pomodoro-long-break-time 5)
(setq pomodoro-work-time 15)
(setq-default mode-line-format
              (cons '(pomodoro-mode-line-string pomodoro-mode-line-string)
                    mode-line-format))
;;config for worf ->  vi-like bindings for org-mode
(add-hook 'org-mode-hook 'worf-mode)

(provide 'prelude-org)

;;; prelude-org.el ends here
