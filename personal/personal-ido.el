(prelude-require-packages '(ido-vertical-mode))

(ido-vertical-mode t)

;;face config like abo-abo
(setq ido-vertical-show-count t)
(setq ido-use-faces t)
(set-face-attribute 'ido-vertical-first-match-face nil
                    :background "#e5b7c0")
(set-face-attribute 'ido-vertical-only-match-face nil
                    :background "#e52b50"
                    :foreground "white")
(set-face-attribute 'ido-vertical-match-face nil
                    :foreground "#b00000")
(ido-vertical-mode 1)
