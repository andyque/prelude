;; add flyspell to markdown and other mode
(require 'company)

(eval-after-load 'company
  '(progn
     (setq company-echo-delay 0)
     (setq company-idle-delay 0.08)
     (setq company-auto-complete nil)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-tooltip-limit 10)
     (setq company-minimum-prefix-length 1)
     ))

(provide 'personal-company)
