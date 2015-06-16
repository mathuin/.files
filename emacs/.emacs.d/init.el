(setq debug-on-error t)

(add-to-list 'load-path user-emacs-directory)
(setq my-settings-path (concat user-emacs-directory "settings/"))
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
