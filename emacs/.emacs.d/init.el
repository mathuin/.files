;;; init.el -- My init file

;;; Commentary:

;;; Code:


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq debug-on-error t)

;;;(add-to-list 'load-path user-emacs-directory)
(defvar my-settings-path (concat user-emacs-directory "settings/"))
(add-to-list 'load-path my-settings-path)

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)

(require 'auto-compile)
(auto-compile-on-load-mode t)
(auto-compile-on-save-mode t)

(setq custom-file (concat my-settings-path "my-customize.el"))
(when (file-exists-p custom-file) (load custom-file))

(when (window-system) (load "my-window"))
(load "my-functions")
(load "my-files")
(load "my-modes")
(load "my-editing")
(load "my-keybindings")
(load "my-styles")

(provide 'init)
;;; init.el ends here
