;; Added for setting up loactions for tmp files
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Added for hooking linum-mode to all major modes
(require 'linum)
(global-linum-mode)

;; Added to introduce space after line number in linum-mode
(setq linum-format "%d ")

;; Turn on parenthesis matching
(show-paren-mode 1)

(defun jao-selective-display ()
"Activate selective display based on the column at point"
(interactive)
(set-selective-display
 (if selective-display
     nil
   (+ 1 (current-column)))))
(global-set-key (kbd "M-c") 'jao-selective-display)

;; Twittering mode
(load "~/.emacs.d/twittering-mode.el")
 (require 'twittering-mode)
(twittering-icon-mode)                      
(setq twittering-timer-interval 300)       
(add-hook 'twittering-mode-hook
           (lambda ()
             (local-set-key "r" 'twittering-replies-timeline)
             (local-set-key "p" 'twittering-user-timeline)
	     (local-set-key "h"  'twittering-home-timeline)
	     (local-set-key "f"  'twittering-follow)
	     (local-set-key (kbd "M-r")  'twittering-retweet)
             (local-set-key "w" 'twittering-update-status-interactive)))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(javascript-auto-indent-flag nil)
 '(javascript-indent-level 2)
 '(js2-auto-indent-p nil)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-indent-on-enter-key nil)
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 136 :width normal :foundry "unknown" :family "Inconsolata")))))
;; js2-mode
(autoload 'js2-mode "~/.emacs.d/js2.elc" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;nitrogen mode
(load "~/.emacs.d/nitrogen-mode.el")
(require 'nitrogen-mode)

;;scala
(add-to-list 'load-path "~/.emacs.d/scala-mode")
(require 'scala-mode-auto)

;;haskell
(load "~/.emacs.d/haskell/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(put 'upcase-region 'disabled nil)


;;support for line movement
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines 1))
    (next-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines -1))
    (move-to-column col)))

(global-set-key [\M-down] 'move-line-down)
(global-set-key [\M-up] 'move-line-up)
(put 'downcase-region 'disabled nil)


;;set key for revert-buffer
(global-set-key (kbd "M-r") 'revert-buffer)


;;nitrogen mode
(load "~/.emacs.d/javascript.el")
(require 'javascript-mode)

(add-to-list 'load-path "~/.emacs.d/emacs-goodies-el")
(load "~/.emacs.d/emacs-goodies-el/color-theme.el")
(require 'color-theme)
(color-theme-initialize)
(color-theme-clarity)


;;enable ido-mode everywhere
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)


;; Install mode-compile to give friendlier compiling support!
(load "~/.emacs.d/mode-compile.el")
(require 'mode-compile)
(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
(global-set-key (kbd "C-c c") 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key (kbd "C-c k") 'mode-compile-kill)


;; Set text-mode as the default mode
(setq-default major-mode 'text-mode)

;; Enable flyspell while in text-mode
(add-hook 'text-mode-hook 'flyspell-mode)

;; Io inf mode
(add-to-list 'load-path "~/.emacs.d/io-emacs")
(require 'io-mode-inf)

;; Io major mode
(load "~/.emacs.d/io-mode.el")
(require 'io-mode)

