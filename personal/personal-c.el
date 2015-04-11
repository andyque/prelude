(prelude-require-packages '(cmake-mode
                            irony
                            flycheck-irony
                            rtags
                            stickyfunc-enhance
                            company-irony
                            cmake-font-lock
                            company-c-headers
                            ;; srefactor
                            ))

(use-package flycheck-irony)

(setq use-package-verbose t)
(defun c-c++/init-cc-mode()
  (use-package c++-mode
               :init
               (progn
                 (require 'semantic/bovine/c)
                 (require 'semantic/ia)
                 (setq semanticdb-default-save-directory
                       (expand-file-name "semanticdb" prelude-savefile-dir))

                 (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
                 ;; (add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)

                 ;; The following settings sometimes is very annoying, flycheck-irony is more sutiable
                 ;; (add-to-list 'semantic-default-submodes 'global-semantic-show-unmatched-syntax-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
                 (add-to-list 'semantic-default-submodes 'global-semantic-highlight-edits-mode)

                 (setq c-default-style "linux") ;; set style to "linux"
                 (setq c-basic-offset 4)
                 (c-set-offset 'substatement-open 0)
                 (setq cc-other-file-alist
                       '(("\\.cpp"   (".h"))
                         ("\\.h"   (".c"".cpp"))))

                 (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
                 (add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
                 (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
                 (add-hook 'c-mode-common-hook 'yas-minor-mode)
                 (add-hook 'c-mode-common-hook 'semantic-mode)
                 (defvar cocos2dx-dir "~/cocos2d-x")
                 (semantic-add-system-include cocos2dx-dir 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/cocos") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/platform") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/audio/include") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/platform/mac") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/extensions") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/external/mac/x86-64/include") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/external/mac/x86-64/include/luajit") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/external/mac/x86-64/include/freetype") 'c++-mode)
                 (semantic-add-system-include (concat cocos2dx-dir "/external/mac/x86-64/include/zlib") 'c++-mode)
                 ;;include path for OpenGL
                 (semantic-add-system-include "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/OpenGL.framework/Versions/A/Headers" 'c++-mode)
                 (add-to-list 'auto-mode-alist (cons cocos2dx-dir 'c++-mode))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_DLL" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("EXPORT_DLL" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("_USRDLL" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_TARGET_OS_MAC" . "1"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("_USRDLL" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_GUI_DLL" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_KEYBOARD_SUPPORT" . "1"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_DEPRECATED_ATTRIBUTE" . ""))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("USE_FILE32API" . "1"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("CC_ENABLE_CHIPMUNK_INTEGRATION" . "1"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-map '("COCOS2D_DEBUG" . "1"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat cocos2dx-dir "/cocos/platform/mac/CCPlatformDefine-mac.h"))
                 (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat cocos2dx-dir "/cocos/platform/CCPlatformMacros.h"))

                 (set-default 'semantic-case-fold t)
                 )
               :config
               (progn
                 (diff-hl-mode -1)

                 ;; configs for semantic db
                 ;; https://martinralbrecht.wordpress.com/2014/11/03/c-development-with-emacs/
                 ;; (require 'srefactor)
                 ;; (define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
                 ;; (define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
                 ;; (add-hook 'srefactor-ui-menu-mode-hook (lambda()(smartparens-mode -1)))
                 ;; ;;modify setters and getters style
                 ;; (setq srefactor--getter-prefix "get")
                 ;; (setq srefactor--setter-prefix "set")


                 ;; (require 'ede)
                 ;; (global-ede-mode)

                 ;; enhancement for sticky mode
                 (require 'stickyfunc-enhance)


                 (require 'function-args)
                 (fa-config-default)
                 )))
(c-c++/init-cc-mode)


(defun c-c++/init-cmake-mode()
  (use-package cmake-mode
               :mode (("CMakeLists\\.txt\\'" . cmake-mode)
                      ("\\.cmake\\'" . cmake-mode)
                      ("\\.mak\\'" . makefile-bsdmake-mode))
               :defer t
               :config
               (progn
                 (defun cmake-rename-buffer ()
                   "Renames a CMakeLists.txt buffer to cmake-<directory name>."
                   (interactive)
                   (when (and (buffer-file-name)
                              (string-match "CMakeLists.txt" (buffer-name)))
                     (setq parent-dir (file-name-nondirectory
                                       (directory-file-name
                                        (file-name-directory (buffer-file-name)))))
                     (setq new-buffer-name (concat "cmake-" parent-dir))
                     (rename-buffer new-buffer-name t)))

                 ;; (autoload 'andersl-cmake-font-lock-activate "andersl-cmake-font-lock" nil t)
                 (require 'cmake-font-lock)
                 (add-hook 'cmake-mode-hook 'cmake-font-lock-activate)
                 (add-hook 'cmake-mode-hook (function cmake-rename-buffer))
                 )
               ))

(c-c++/init-cmake-mode)


(defun c-c++/init-company()
  (use-package company
    :defer t
    :config
    (progn
  (setq company-backends (delete 'company-semantic company-backends))
  (setq company-backends (delete 'company-clang company-backends))
  (add-to-list 'company-backends 'company-c-headers)
  (setq company-c-headers-path-system
    (quote
     ("/usr/include/" "/usr/local/include/" "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1")))
  (setq company-c-headers-path-user
    (quote
     ("/Users/guanghui/cocos2d-x/cocos/platform" "/Users/guanghui/cocos2d-x/cocos" "." "/Users/guanghui/cocos2d-x/cocos/audio/include/")))
  )))

(c-c++/init-company)

(defun prelude-makefile-mode-defaults ()
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t ))

(setq prelude-makefile-mode-hook 'prelude-makefile-mode-defaults)

(add-hook 'makefile-mode-hook (lambda ()
                                (run-hooks 'prelude-makefile-mode-hook)))


(add-hook 'c++-mode-hook
          '(lambda ()
             (progn
              (eval-after-load 'flycheck
                '(add-to-list 'flycheck-checkers 'irony))
               ;; (gtags-mode t)
               ;; (diminish 'gtags-mode)
               (local-set-key (kbd "C-.") 'company-c-headers)
               (local-set-key (kbd "C-M-k") 'irony-server-kill)
               )
))




(defun c-c++/init-irony()
  (use-package irony
    :defer t
    :init
    (progn
      (add-hook 'c++-mode-hook 'irony-mode)
      ;; (add-hook 'c-mode-hook 'irony-mode)
      (add-hook 'objc-mode-hook 'irony-mode)

      ;; replace the `completion-at-point' and `complete-symbol' bindings in
      ;; irony-mode's buffers by irony-mode's function
      (defun my-irony-mode-hook ()
        (define-key irony-mode-map [remap completion-at-point]
          'irony-completion-at-point-async)
        (define-key irony-mode-map [remap complete-symbol]
          'irony-completion-at-point-async)
        (add-to-list 'company-backends 'company-irony))

      (add-hook 'irony-mode-hook 'my-irony-mode-hook)
      ;; it is not fast and accurate
      ;; (add-hook 'irony-mode-hook 'irony-eldoc)

      (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
      (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

      )))

(c-c++/init-irony)

;;add doxyemacs
(add-to-list 'load-path "~/.emacs.d/site-lisp/doxyemacs")
(require 'doxymacs)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
(add-hook 'c-mode-common-hook'doxymacs-mode)

;; http://stackoverflow.com/questions/23553881/emacs-indenting-of-c11-lambda-functions-cc-mode
(defadvice c-lineup-arglist (around my activate)
  "Improve indentation of continued C++11 lambda function opened as argument."
  (setq ad-return-value
        (if (and (equal major-mode 'c++-mode)
                 (ignore-errors
                   (save-excursion
                     (goto-char (c-langelem-pos langelem))
                     ;; Detect "[...](" or "[...]{". preceded by "," or "(",
                     ;;   and with unclosed brace.
                     (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))
            0                           ; no additional indent
          ad-do-it)))                   ; default behavior

(provide 'prelude-c)

;;; prelude-c.el ends here
