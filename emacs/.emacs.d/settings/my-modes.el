(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode" "Major mode for editing Github Flavored Markdown files" t)
(add-to-list 'auto-mode-alist (cons "\\.md" 'gfm-mode))

(add-to-list 'auto-mode-alist (cons "\\.cl$" 'c-mode))


(add-hook 'after-init-hook #'global-flycheck-mode)


