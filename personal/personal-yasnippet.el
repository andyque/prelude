;; [[http://qiita.com/kai2nenobu/items/5dfae3767514584f5220][Emacs - Write a high readability init.el in use-package - Qiita]]
(use-package yasnippet
  :ensure t
  :defer t
  :config
  (progn
    (add-to-list 'yas/root-directory "~/.emacs.d/yasnippet-snippets/")
    (setq-default yas-prompt-functions '(yas-ido-prompt yas-dropdown-prompt))
    )
  )

(provide 'prelude-yasnippet)
