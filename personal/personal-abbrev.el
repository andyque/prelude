(prelude-require-packages '(use-package
                             popwin
                             ))
(require 'use-package)

(use-package abbrev
  :defer t
  :config
  (progn

    (define-abbrev-table 'global-abbrev-table '(

                                                ;; math/unicode symbols
                                                ("8in" "∈")
                                                ("8nin" "∉")
                                                ("8inf" "∞")
                                                ("8luv" "♥")
                                                ("8smly" "☺")

                                                ;; email
                                                ("8me" "guanghui.qu@cocos2d-x.org")

                                                ;; computing tech
                                                ("8wp" "Wikipedia")
                                                ("8ms" "Microsoft")
                                                ("8g" "Google")
                                                ("8it" "IntelliType")
                                                ("8msw" "Microsoft Windows")
                                                ("8win" "Windows")
                                                ("8ie" "Internet Explorer")
                                                ("8ahk" "AutoHotkey")
                                                ("82dx" "Cocos2D-X")

                                                ;; signature
                                                ("zl" "zilongshanren")
                                                ;; emacs regex
                                                ("8d" "\\([0-9]+?\\)")
                                                ("8str" "\\([^\"]+?\\)\"")


                                                ))

    ;; stop asking whether to save newly added abbrev when quitting emacs
    (setq save-abbrevs nil)

    ;; turn on abbrev mode globally
    (setq-default abbrev-mode t)
    )
  :diminish abbrev-mode
  )

(provide 'prelude-abbrev)
