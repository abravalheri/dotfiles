;;; Environment Config
(setenv "GIT_ASKPASS" "git-gui--askpass")

;;; Setup Packages
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;; Package list

;; In `use-package`
;; `:ensure t` will install the package
;; `:init` will run commands before activating the package
;; `:config` will run commands after activating the package

(use-package magit
  :ensure t
  :config (global-set-key (kbd "C-x g") #'magit-status))

(use-package ssh-agency :ensure t)

(use-package company
  :ensure t
  :config
    (add-hook 'after-init-hook 'global-company-mode)
    (setq company-idle-delay 0.2)
    (setq company-selection-wrap-around t)
    (define-key company-active-map [tab] 'company-complete)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package smex
  :ensure t
  :config
    (smex-initialize)
    (global-set-key (kbd "M-x") 'smex)
    (global-set-key (kbd "M-X") 'smex-major-mode-commands)
    ;; This is your old M-x.
    (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(use-package evil
  :ensure t
  :config
    (evil-mode 1)
    (define-key evil-motion-state-map (kbd ":") 'evil-repeat-find-char)
    (define-key evil-motion-state-map (kbd ";") 'evil-ex)
    (defvar leader-map (make-sparse-keymap)
      "Keymap for \"leader key\" shortcuts.")
    ;; binding "SPC" to the keymap
    (define-key evil-normal-state-map (kbd "SPC") leader-map)
    (define-key leader-map (kbd "w") 'toggle-word-mode)
    (define-key leader-map (kbd "g s") #'magit-status))

(use-package evil-magit :ensure t)

(use-package evil-goggles
  :ensure t
  :config
    (evil-goggles-mode)
    (evil-goggles-use-diff-faces))

(use-package evil-surround
  :ensure t
  :config (global-evil-surround-mode))

;; (use-package evil-unimpaired
  ;; :ensure t
  ;; :config (evil-unimpaired-mode))

(use-package evil-commentary
  :ensure t
  :config (evil-commentary-mode))

(use-package evil-visualstar
  :ensure t
  :config (global-evil-visualstar-mode))

(use-package vi-tilde-fringe
  :ensure t
  :config (global-vi-tilde-fringe-mode))

(use-package nlinum-relative
  :ensure t
  :config
    (nlinum-relative-setup-evil)
    (global-nlinum-relative-mode t))

(use-package flycheck
  :ensure t
  :init (setq flycheck-check-syntax-automatically '(save mode-enabled))
  :config (global-flycheck-mode))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(use-package markdown-toc :ensure t)

(use-package org-bullets
  :ensure t
  :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode t))))

(use-package evil-org
  :ensure t
  :after org
  :config
    (add-hook 'org-mode-hook #'evil-org-mode)
    (add-hook 'evil-org-mode-hook #'evil-org-set-key-theme)
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys))

(use-package yasnippet
  :ensure t
  :config
    (yas-reload-all)
    (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package yasnippet-snippets :ensure t)

(use-package dumb-jump :ensure t)

(use-package restclient :ensure t)

;;; Built-in packages config

(setq-default fill-column 79)

(setq
  ido-enable-flex-matching t
  ido-everywhere t
  ido-use-filename-at-point 'guess)
(ido-mode t)

(show-paren-mode t)
(superword-mode t)
(subword-mode nil)

(require 'tramp)
(setq
  tramp-debug-buffer t
  tramp-verbose 10
  tramp-auto-save-directory (getenv "TEMP")
  tramp-default-method "plink")

(defalias 'list-buffers 'ibuffer)

(defun toggle-word-mode ()
  (superword-mode)
  (subword-mode))

(require 'dired )
(add-hook 'dired-mode-hook
  (lambda ()
    (require 'dired-x)
    (dired-hide-details-mode)))
;; Avoid dired opening to much buffers
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))  ; was dired-up-directory

;;; Eshell aliases
(defun eshell/e (file) (find-file file))
(defun eshell/emacs (file) (find-file file))

;;; UI
;; Set default font
(set-face-attribute 'default nil
  :family "Fira Mono"
  :height 110
  :weight 'normal
  :width 'normal)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (leuven)))
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (use-package)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))
(put 'dired-find-alternate-file 'disabled nil)
