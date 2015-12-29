;;; my-modes.el --- My modes

;;; Commentary:

;;; Code:

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode" "Major mode for editing Github Flavored Markdown files" t)
(add-to-list 'auto-mode-alist (cons "\\.md" 'gfm-mode))

(add-to-list 'auto-mode-alist (cons "\\.cl$" 'c-mode))

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-flake8-maximum-line-length 1200)

(defvar magit-last-seen-setup-instructions "1.4.0")

(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(provide 'my-modes)
;;; my-modes.el ends here

