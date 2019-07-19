;;; private/custom/config.el -*- lexical-binding: t; -*-

(defun personal/configurations ()
  "Defines lazy configurations to be performed after emacs startup"
  (load! "+keybindings")
  (setq-default fill-column 79)
  (subword-mode t)
  (superword-mode t)
  (add-to-list 'display-buffer-alist
               '("^\\*shell\\*$" . (display-buffer-same-window)))
  (add-to-list 'display-buffer-alist
               '("^\\*Ibuffer\\*$" . (display-buffer-same-window))))

(add-hook! 'emacs-startup-hook #'personal/configurations)

;; Standalone Configurations (don't require packages to be loaded)
;; Configurations that need to be done before doom is loaded
(defun font-exists-p (font)
  "Check if font exists"
  (if (null (x-list-fonts font)) nil t))

(when (and (display-graphic-p)
           (font-exists-p "Fira Code")
           (font-exists-p "Fira Sans"))
  (setq
   doom-font (font-spec :family "Fira Code" :size 14)
   doom-variable-pitch-font (font-spec :family "Fira Sans")
   doom-unicode-font (font-spec :family "Fira Code")
   doom-big-font (font-spec :family "Fira Code" :size 21)))

(setq
 projectile-project-search-path '("~/projects/" "~/papers")
 projectile-enable-caching t)

(setq-default
 display-line-numbers-type 'relative
 display-line-numbers-current-absolute t)

;; Add new packages
(def-package! seeing-is-believing
  :config
  (add-hook 'ruby-mode-hook 'seeing-is-believing))

(def-package! evil-text-object-python
  :config
  (add-hook 'python-mode-hook 'evil-text-object-python-add-bindings))

(def-package! elpy
  :config
  (add-hook 'python-mode-hook 'elpy-enable))

;; ;; Reconfigure existing packages
(add-hook! 'dired-mode-hook #'dired-hide-details-mode)

;; (after! evil-snipe (evil-snipe-mode -1)) ; no mangling with s/S behaviour
;; ^ TODO: return this linex once evil-snipe is fixed

;; Quite emacs without confirmining
;; (setq confirm-kill-emacs nil)

;; Custom functions
(defun toggle-word-mode ()
  "Toggle between superword and subword modes:
   superword defines a word that expands across underscores, camelcases, dashes, etc...
   subword defines a word that stops before any undersconres, camelcases, etc..."
  (superword-mode)
  (subword-mode))

;;; Eshell aliases
(defun eshell/e (file) (find-file file))
(defun eshell/emacs (file) (find-file file))
