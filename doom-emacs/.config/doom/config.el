;;; private/custom/config.el -*- lexical-binding: t; -*-

(setq-default fill-column 79)

(load (expand-file-name "+keybindings" (file-name-directory load-file-name)))

(def-package! seeing-is-believing
  :config
  (add-hook 'ruby-mode-hook 'seeing-is-believing))

(def-package! evil-text-object-python
  :config
  (add-hook 'python-mode-hook 'evil-text-object-python-add-bindings))

(def-package! elpy
  :config
  (add-hook 'python-mode-hook 'elpy-enable))

(add-to-list 'display-buffer-alist
             '("^\\*shell\\*$" . (display-buffer-same-window)))

(add-to-list 'display-buffer-alist
             '("^\\*Ibuffer\\*$" . (display-buffer-same-window)))
