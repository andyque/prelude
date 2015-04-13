;;; package --- hydra keybindings
;;; Commentary:
;;; Github repo:https://github.com/abo-abo/hydra
;;; Code:

(prelude-require-packages '(hydra
                            rtags
                            ))

(require 'personal-tools)

;;define hydra for tools
(defhydra hydra-tools (:color red)
  "
 Youdao: _y_  Dash: _d_  Weibo: _w_
"
  ("y" youdao-dictionary-search-at-point nil :exit t)
  ("d" dash-at-point nil :exit t)
  ("w" weibo-timeline nil :exit t)
  ("q"  nil "quit"))

(defhydra hydra-zoom (global-map "C-M-z")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-error (global-map "M-g")
  "goto-error"
  ("h" flycheck-previous-error "first")
  ("j" flycheck-next-error "next")
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


(defhydra helm-key-bindings(:color teal)
  "
 Helm:
_o_: swoop    _i_menu:       _d_wim:       _r_tags:       _s_ymbol:       _f_unction:       _p_aste kill ring:
"
  ("o" helm-swoop nil)
  ("i" helm-imenu nil)
  ("d" helm-gtags-dwim nil)
  ("r" helm-gtags-find-rtag nil)
  ("s" helm-gtags-find-symbol nil)
  ("f" helm-find-files nil)
  ("p" helm-show-kill-ring nil)
  ("q" nil nil  :color blue))

(defhydra magit-key-bindings(:color teal)
  "
 Magit:
_s_tatus w
_l_og:
_b_lame:
"
  ("s" magit-status nil)
  ("l" magit-file-log nil)
  ("b" magit-blame-mode nil)
  ("q" nil nil :color blue)
  )

(defhydra hydra-git-gutter
    (:pre (git-gutter-mode 1))
  "
Git:
_j_: next hunk        _s_tage hunk     _q_uit
_k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
                      _p_opup hunk

set start _R_evision
"
  ("j" git-gutter:next-hunk          nil)
  ("k" git-gutter:previous-hunk      nil)
  ("s" git-gutter:stage-hunk         nil)
  ("r" git-gutter:revert-hunk        nil)
  ("p" git-gutter:popup-hunk         nil)
  ("R" git-gutter:set-start-revision nil)
  ("q" nil                  nil :color blue)
  ("Q" (git-gutter-mode -1) nil :color blue))

(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))

(defhydra hydra-projectile (:color teal)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_f_: file            _a_: ag                _i_: helm buffer list           _c_: cache clear
_r_: recent file     _g_: update gtags      _b_: switch to buffer  _x_: remove known project
_d_: dir             _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
                     ^^^^_y_: copy filename            _z_: cache current

"
  ("a"   helm-ag                      nil)
  ("b"   projectile-switch-to-buffer        nil)
  ("c"   projectile-invalidate-cache        nil)
  ("d"   projectile-find-dir                nil)
  ("f"   helm-browse-project               nil) ;;http://stackoverflow.com/questions/14313851/emacs-opening-any-file-in-a-large-repo
  ;; ("ff"  projectile-find-file-dwim          nil)
  ("g"   ggtags-update-tags                 nil)
  ;; ("s-g" ggtags-update-tags                 nil)
  ("i"   helm-buffers-list                 nil)
  ;; ("I"   ibuffer                 nil)
  ("K"   projectile-kill-buffers            nil)
  ("s-k" projectile-kill-buffers            nil)
  ("y"   prelude-copy-file-name-to-clipboard             nil)
  ("o"   projectile-multi-occur             nil)
  ("s-p" projectile-switch-project          "switch project")
  ("p"   projectile-switch-project          nil)
  ("s"   projectile-switch-project          nil)
  ("r"   projectile-recentf                 nil)
  ("x"   projectile-remove-known-project    nil)
  ("X"   projectile-cleanup-known-projects  nil)
  ("z"   projectile-cache-current-file      nil)
  ("`"   hydra-projectile-other-window/body "other window")
  ("q"   nil                                "cancel" :color blue))





(defhydra c++-compile-run-key-bindings (:color teal)
  "
 C++-mode:
_b_uild
"
  ("b" zilongshanren/compile nil)
  ("r" zilongshanren/run nil)
  ("q" nil nil :color blue)
  )

(defhydra org-key-bindings (:color teal)
  "
 Org-mode:
_a_genda:   _l_ink:  _c_apture:  _t_odo:       _T_ags:      _h_tml presentation:

"
  ("a" org-agenda nil)
  ("l" org-mac-grab-link nil)
  ("L" jcs-get-link)
  ("c" org-capture nil)
  ("t" org-todo nil)
  ("T" org-set-tags-command nil)
  ("h" org-reveal-export-to-html-and-browse nil)
  ("q" nil nil :color blue)
  )

(evil-leader/set-key
  "p" 'hydra-projectile/body
  "e"  'hydra-error/body
  "g"  'hydra-git-gutter/body
  "o"  'org-key-bindings/body
  "h"  'helm-key-bindings/body
  "m"  'magit-key-bindings/body
  "t"  'hydra-tools/body
  )

(evil-leader/set-key-for-mode 'c++-mode "b" 'c++-compile-run-key-bindings/body)


;; rtags
(require 'rtags)
(defhydra rtags-key-bindings(:color teal)
  "
 Rtags:
_s_ymbol:   _i_menu:    _f_ile:     _r_eference:    _v_isual:
"
  ("s" rtags-find-symbol nil)
  ("i" rtags-imenu nil)
  ("f" rtags-find-file nil)
  ("r" rtags-find-references nil)
  ("v" rtags-find-virtuals-at-point nil)
  ("q" nil nil  :color blue))


(evil-leader/set-key-for-mode 'c++-mode "r" 'rtags-key-bindings/body)

(defhydra hydra-marked-items (dired-mode-map "")
  "
Number of marked items: %(length (dired-get-marked-files))
"
  ("m" dired-mark "mark"))

(define-key dired-mode-map
  "m" 'hydra-marked-items/dired-mark)
(provide 'personal-hydra)
;;; personal-hydra.el ends here
