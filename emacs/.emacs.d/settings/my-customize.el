;;; my-customize.el -- My customization settings

;;; Commentary:

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((python-shell-prompt-output-regexp . "Out\\[[0-9]+\\]: ")
     (python-shell-prompt-regexp . "In \\[[0-9]+\\]: ")
     (python-shell-interpreter-args . "manage.py shell")
     (python-shell-interpreter . "python")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'my-customize)
;;; my-customize.el ends here
