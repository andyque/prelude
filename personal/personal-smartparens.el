(prelude-require-packages '(smartparens))

(require 'smartparens-ruby)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

(sp-pair "`" nil :actions :rem)
(setq sp-autoescape-string-quote nil)

(require 'smartparens-lua)
(sp-with-modes '(lua-mode)
 (sp-local-pair "for" nil :actions :rem)
 (sp-local-pair "if" nil :actions :rem)
 (sp-local-pair "while" nil :actions :rem)
 (sp-local-pair "function" nil :actions :rem)
 )


(smartparens-global-mode t)

(setq show-paren-style 'parethesis)

(provide 'prelude-smartparens)
