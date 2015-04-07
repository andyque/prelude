;; add flyspell to markdown and other mode
(require 'flyspell)


;; (add-hook 'org-mode-hook 'turn-on-flyspell)
;; (add-hook 'markdown-mode-hook 'turn-on-flyspell)

;; you can also use "M-x ispell-word" or hotkey "M-$". It pop up a multiple choice
;; @see http://frequal.com/Perspectives/EmacsTip03-FlyspellAutoCorrectWord.html
(global-unset-key (kbd "C-c s"))
(global-set-key (kbd "C-c s") 'flyspell-auto-correct-word)

(provide 'prelude-flyspell)
