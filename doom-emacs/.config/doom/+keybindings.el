;;; private/custom/+keybindings.el -*- lexical-binding: t; -*-

(map!
 :nv ";" #'evil-ex
 :nv ":" #'evil-repeat-find-char
 ;; Swap evil-collection dired's : and ;
 (:after dired
   :map dired-mode-map
   :nv ";"  #'evil-ex
   :nv ":d" #'epa-dired-do-decrypt
   :nv ":v" #'epa-dired-do-verify
   :nv ":s" #'epa-dired-do-sign
   :nv ":e" #'epa-dired-do-encrypt)
 (:after org
   :map org-mode-map
   :nv "M-k" #'org-metaup
   :nv "M-j" #'org-metadown))

(provide '+keybindings)
