;;; Code:

(prelude-require-packages '(perspective
                            persp-projectile
                            projectile))

(persp-mode)
(require 'persp-projectile)

(define-key projectile-mode-map (kbd "s-p") 'projectile-persp-switch-project)

(provide 'prelude-perspective)
;;; prelude-perspective.el ends here
