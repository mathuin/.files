(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((python-shell-interpreter-args . "manage.py shell") (python-shell-interpreter . "python")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/git/dominikh/go-mode.el")
(add-to-list 'load-path "~/git/fgallina/python.el")
(add-to-list 'load-path "~/git/bsvingen/sql-indent")
(add-to-list 'load-path "~/gopath/src/github.com/dougm/goflymake")
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode" "Major mode for editing Github Flavored Markdown files" t)
(setq gofmt-command "goimports")
(autoload 'go-mode "go-mode" "Major mode for editing Go code" t)
(setq auto-mode-alist
      (cons '("\\.md" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist 
      (cons '("\.cl$" . c-mode) auto-mode-alist))
(setq auto-mode-alist 
      (cons '("\.go$" . go-mode) auto-mode-alist))
(require 'python-django)
(require 'go-flymake)
(global-set-key (kbd "C-x j") 'python-django-open-project)

(defun my-go-mode-hook ()
  (setq tab-width 4)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pep8-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "pep8" (list "--repeat" local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pep8-init))

  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py.dist\\'" flymake-pep8-init))

  (defun flymake-rst-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "/home/jmt/git/tkf/rstcheck/rstcheck.py" (list local-file))))
 
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.rst\\'" flymake-rst-init)))

(defun flymake-get-tex-args (file-name)
  (list "chktex" (list "-q" "-v0" file-name)))

(defun my-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))

(add-hook 'post-command-hook 'my-flymake-show-help)

(defvar my-flymake-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\M-p" 'flymake-goto-prev-error)
    (define-key map "\M-n" 'flymake-goto-next-error)
    map)
  "Keymap for my flymake minor mode.")

(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(defadvice flymake-goto-next-error (after display-message activate compile)
  (my-flymake-err-echo))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  (my-flymake-err-echo))

(define-minor-mode my-flymake-minor-mode
  "Simple minor mode which adds some key bindings for moving to the next and previous errors.

Key bindings:

\\{my-flymake-minor-mode-map}"
  nil
  nil
  :keymap my-flymake-minor-mode-map)

;; Enable this keybinding (my-flymake-minor-mode) by default
;; Added by Hartmut 2011-07-05
(add-hook 'python-mode-hook 'my-flymake-minor-mode)
(add-hook 'latex-mode-hook 'my-flymake-minor-mode)
(add-hook 'go-mode-hook 'my-flymake-minor-mode)

;; check that rst is valid when saving
(defun rst-validate-buffer ()
  "Tests to see if buffer is valid reStructured Text."
  (interactive)
  (if (eq major-mode 'rst-mode)         ; only runs in rst-mode
      (let ((name (buffer-name))
            (filename (buffer-file-name)))
        (cond
         ((not (file-exists-p "/usr/bin/rst2pseudoxml")) ; check that the program used to process file is present
	  (error "Docutils programs not available."))
         ((not (file-exists-p filename)) ; check that the file of the buffer exists
	  (error "Buffer '%s' is not visiting a file!" name))
         (t                             ; ok, process the file, producing pseudoxml output
          (let* ((pseudoxml (split-string (shell-command-to-string (concat "rst2pseudoxml " filename)) "\n"))
                 (firstline (car pseudoxml)) ; take first line of output
                 (lastline (nth (- (length pseudoxml) 2) pseudoxml))) ; take last line of output text
            (if (or (string-match "ERROR/" firstline)
                    (string-match "WARNING/" firstline)
                    ;; for reasons I don't understand, sometimes the warnings/errors are at the end of output
                    (string-match "ERROR/" lastline)
                    (string-match "WARNING/" lastline))
                (progn (ding)
                       (message "There's an problem in this buffer."))
              (message "Buffer is valid reStructured Text."))))))))

(add-hook 'rst-mode-hook
          (lambda()
	    (add-hook 'after-save-hook 'rst-validate-buffer)))

(setq vc-follow-symlinks t)
