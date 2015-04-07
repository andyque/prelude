;;; package --- personal global key-binding configuration
;;; Commentary:
;;; Code:

(prelude-require-packages '(keyfreq
                            ido-occasional
                            helm-ls-git
                            ))

(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "C-:") 'dired-jump)
(define-key org-mode-map (kbd "<s-return>") 'org-meta-return)

(defhydra hydra-zoom (global-map "C-M-z")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-error (global-map "M-g")
  "goto-error"
  ("h" first-error "first")
  ("j" next-error "next")
  ("k" previous-error "prev")
  ("v" recenter-top-bottom "recenter")
  ("q" nil "quit"))

;;* Windmove helpers
(require 'windmove)

(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(defhydra hydra-window (:color red)
  "
 Split: _v_ert _x_:horz
Delete: _o_nly  _dw_indow  _db_uffer
  Misc: _m_ark _s_witch "
  ("h" windmove-left nil)
  ("j" windmove-down nil)
  ("k" windmove-up nil)
  ("l" windmove-right nil)
  ("H" hydra-move-splitter-left nil)
  ("J" hydra-move-splitter-down nil)
  ("K" hydra-move-splitter-up nil)
  ("L" hydra-move-splitter-right nil)
  ("|" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)) nil)
  ("_" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down)) nil)
  ("v" split-window-right nil)
  ("x" split-window-below nil)
  ;("t" transpose-frame "'")
  ;; ("u" winner-undo nil) ;;FIXME: not working?
  ;; ("r" winner-redo nil) ;;Fixme, not working?
  ("o" delete-other-windows nil :exit t)
  ("s" switch-window nil :exit t)
  ;; ("f" new-frame nil :exit t)
  ("dw" delete-other-window nil)
  ("db" kill-this-buffer nil)
  ;; ("df" delete-frame nil :exit t)
 ("q" nil nil)
  ;("i" ace-maximize-window "ace-one" :color blue)
  ;("b" ido-switch-buffer "buf")
  ("m" headlong-bookmark-jump nil))

(evil-leader/set-key "w" 'hydra-window/body)
(define-key global-map (kbd "C-M-o") 'hydra-window/body)

;; track emacs commands frequency
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(global-set-key "\C-s" 'swiper)

;; keybindings for apropos

(defhydra hydra-apropos (:color blue
                                :hint nil)
  "
_a_propos        _c_ommand
_d_ocumentation  _l_ibrary
_v_ariable       _u_ser-option
^ ^          valu_e_"
  ("a" apropos)
  ("d" apropos-documentation)
  ("v" apropos-variable)
  ("c" apropos-command)
  ("l" apropos-library)
  ("u" apropos-user-option)
  ("e" apropos-value))

(global-set-key (kbd "C-c h") 'hydra-apropos/body)

(global-set-key (kbd "C-h f") (with-ido-completion describe-function ))
(global-set-key (kbd "C-h C-f") (with-ido-completion find-function ))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "s-t") 'helm-ls-git-ls)
(global-set-key (kbd "s-w") 'delete-window)


(provide 'personal-global-keybinding)
