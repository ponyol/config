;;; -*- lexical-binding: t; -*-

;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name
;;         "straight/repos/straight.el/bootstrap.el"
;;         (or (bound-and-true-p straight-base-dir)
;;             user-emacs-directory)))
;;       (bootstrap-version 7))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

(require 'package)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")
                          ;; ("marmalade" . "https://marmalade-repo.org/packages/")
                          ;; ("org" . "https://orgmode.org/elpa/")
                          ;; ("user42" . "https://download.tuxfamily.org/user42/elpa/packages/")
                          ;; ("emacswiki" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/emacswiki/")
                          ;; ("sunrise" . "http://joseito.republika.pl/sunrise-commander/")
                          ))
(customize-set-variable 'package-enable-at-startup nil)
(package-initialize)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'use-package)
(setq read-process-output-max (* 1024 1024)) ;; 1 MB
(setq max-specpdl-size 13000)      ;; default 1300
(setq max-lisp-eval-depth 10000)   ;; default 600

;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; (eval-when-compile
;;   (require 'use-package))

;; (put 'use-package 'lisp-indent-function 1)

(use-package use-package-core
  :custom
  ;; (use-package-verbose t)
  ;; (use-package-minimum-reported-time 0.005)
  (use-package-enable-imenu-support t))

(use-package org
  :pin gnu)

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-z"))  ; pick your own prefix key here
  :init
  (persp-mode))

(add-hook 'kill-emacs-hook #'persp-state-save)

(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1))

(use-package system-packages
  :ensure t
  :custom
  (system-packages-noconfirm t))

;; (use-package use-package-ensure-system-package :ensure t)

(use-package quelpa
  :ensure t
  :defer t
  :custom
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo."))

(use-package quelpa-use-package :ensure t)

(use-package use-package-custom-update
  :quelpa
  (use-package-custom-update
   :repo "a13/use-package-custom-update"
   :fetcher github
   :version original))

(use-package use-package-secrets
  :custom
  (use-package-secrets-directories '("~/.emacs.d/secrets"))
  :quelpa
  (use-package-secrets
   :repo "a13/use-package-secrets"
   :fetcher github
   :version original))

(use-package try
  :ensure t
  :defer t)

(use-package emacs-everywhere
  :ensure t
  :defer t)

(use-package jinja2-mode
  :quelpa
  (jinja2-mode
   :repo "paradoxxxzero/jinja2-mode"
   :fetcher github
   :version original
   :mode ("\\.j2\\'" . jinja2-mode)))

;;(use-package paradox
;;  :ensure t
;;  :defer 1
;;  :config
;;  (paradox-enable))

(use-package emacs
  :init
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  :custom
  (scroll-step 1)
  (inhibit-startup-screen t "Don't show splash screen")
  (use-dialog-box nil "Disable dialog boxes")
  (x-gtk-use-system-tooltips nil)
  (enable-recursive-minibuffers t "Allow minibuffer commands in the minibuffer")
  (indent-tabs-mode nil "Spaces!")
  (tab-width 4)
  (debug-on-quit nil))

(use-package frame
  :bind
  ("C-z" . nil))

(use-package delsel
  :bind
  (:map mode-specific-map
        ("C-g" . minibuffer-keyboard-quit)))

;; (use-package simple
;;   :custom
;;   (kill-ring-max 3000)
;;   :config
;;   (column-number-mode t)
;;   (toggle-truncate-lines 1)
;;   :bind
;;   ;; remap ctrl-w/ctrl-h
;;   (("C-w" . backward-kill-word)
;;    ("C-h" . delete-backward-char)
;;    :map ctl-x-map
;;    ("C-k" . kill-region)
;;    ("K" . kill-current-buffer)))

(use-package help
  :bind
  (("C-?" . help-command)
   :map mode-specific-map
   ("h" . help-command)))

(require 'uniquify)

(use-package ibuffer
  :bind ("M-z" . bs-show)
  :config
  (defalias 'list-buffers 'ibuffer))

(use-package files
  :hook
  (before-save . delete-trailing-whitespace)
  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  (backup-directory-alist
   `((".*" . ,(locate-user-emacs-file "backups"))))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ponyol5
(use-package autorevert
  :defer 0.1)

(use-package recentf
  :defer 0.1
  :custom
  (recentf-auto-cleanup 30)
  :config
  (run-with-idle-timer 30 t 'recentf-save-list))

;; (use-package iqa
;;   :ensure t
;;   :custom
;;   (iqa-user-init-file (locate-user-emacs-file "README.org")
;;                       "Edit README.org by default.")
;;   :config
;;   (iqa-setup-default))

(use-package cus-edit
  :custom
  (custom-file (expand-file-name "custom-vars.el" user-emacs-directory) "Don't load customizations"))

(use-package vlf
  :defer t
  :ensure t
  :after (ivy counsel)
  :init
  (ivy-add-actions 'counsel-find-file '(("l" vlf "view large file"))))

(use-package epa
  :defer t
  :custom
  (epg-gpg-program "gpg")
  (epa-pinentry-mode nil))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward))

(use-package tramp
  :defer t
  :config
  (put 'temporary-file-directory 'standard-value `(,temporary-file-directory))
  :custom
  (tramp-backup-directory-alist backup-directory-alist)
  (tramp-default-method "ssh")
  (tramp-default-proxies-alist nil))

(use-package sudo-edit
  :ensure t
  :bind (:map ctl-x-map
              ("M-s" . sudo-edit)))

;; (use-package exec-path-from-shell
;;   :ensure t
;;   :defer 0.1
;;   :config
;;   (exec-path-from-shell-initialize))

(use-package em-smart
  :defer t
  :config
  (eshell-smart-initialize)
  :custom
  (eshell-where-to-jump 'begin)
  (eshell-review-quick-commands nil)
  (eshell-smart-space-goes-to-end t))

(use-package esh-help
  :ensure t
  :defer t
  :config
  (setup-esh-help-eldoc))

(use-package esh-autosuggest
  :ensure t
  :hook (eshell-mode . esh-autosuggest-mode))

(use-package esh-module
  :custom-update
  (eshell-modules-list '(eshell-tramp)))

(use-package eshell-prompt-extras
  :ensure t
  :after esh-opt
  :custom
  (eshell-prompt-function #'epe-theme-dakrone))

(use-package eshell-toggle
  :ensure t
  :custom
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil)
  :bind
  ("M-`" . eshell-toggle))

(use-package eshell-fringe-status
  :ensure t
  :hook
  (eshell-mode . eshell-fringe-status-mode))

(use-package ls-lisp
  :defer t
  :custom
  (ls-lisp-emulation 'MS-Windows)
  (ls-lisp-ignore-case t)
  (ls-lisp-verbosity nil))

(use-package dired
  :custom (dired-dwim-target t "guess a target directory")
  :hook
  (dired-mode . dired-hide-details-mode))

(use-package dired-x
  :bind
  ([remap list-directory] . dired-jump)
  :custom
  ;; do not bind C-x C-j since it's used by jabber.el
  (dired-bind-jump nil))

(use-package dired-toggle
  :ensure t
  :defer t)

(use-package dired-hide-dotfiles
  :ensure t
  :bind
  (:map dired-mode-map
        ("." . dired-hide-dotfiles-mode))
  :hook
  (dired-mode . dired-hide-dotfiles-mode))

(use-package diredfl
  :ensure t
  :hook
  (dired-mode . diredfl-mode))

(use-package async
  :ensure t
  :defer t
  :init
  (dired-async-mode t))

(use-package dired-rsync
  :ensure t
  :bind
  (:map dired-mode-map
        ("r" . dired-rsync)))

(use-package dired-launch
  :ensure t
  :hook
  (dired-mode . dired-launch-mode))

(use-package dired-git-info
  :ensure t
  :bind
  (:map dired-mode-map
        (")" . dired-git-info-mode)))

(use-package mule
  :config
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-terminal-coding-system 'utf-8))

;; (use-package ispell
;;   :defer t
;;   :custom
;;   (ispell-local-dictionary-alist
;;    '(("russian"
;;       "[АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
;;       "[^АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
;;       "[-']"  nil ("-d" "uk_UA,ru_RU,en_US") nil utf-8)))
;;   (ispell-program-name "hunspell")
;;   (ispell-dictionary "russian")
;;   (ispell-really-aspell nil)
;;   (ispell-really-hunspell t)
;;   (ispell-encoding8-command t)
;;   (ispell-silently-savep t))

;; (use-package flyspell
;;   :defer t
;;   :custom
;;   (flyspell-delay 1))

;; (use-package flyspell-correct-ivy
;;   :ensure t
;;   :demand t
;;   :bind (:map flyspell-mode-map
;;               ("C-c $" . flyspell-correct-at-point)))

;;(use-package faces
;;  :defer t
;;  :custom
;;  (face-font-family-alternatives '(("Consolas" "Monaco" "Monospace")))
;;  :custom-face
;;  (default ((t (:family "Consolas" :height 95))))
;;  ;; workaround for old charsets
;;  :config
;;  (set-fontset-font "fontset-default" 'cyrillic
;;                    (font-spec :registry "iso10646-1" :script 'cyrillic)))

;;;;;;;;;;;;;;;;;;;;;;;;;; emacs destroy
;; (use-package font-lock
;;   :custom-face
;;   (font-lock-string-face ((t (:inherit font-lock-string-face :italic t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ponyol6
(use-package lor-theme
  :config
  (load-theme 'lor t)
  :quelpa
  (lor-theme :repo "a13/lor-theme" :fetcher github :version original))

(use-package tool-bar
  :config
  (tool-bar-mode -1))

(use-package scroll-bar
  :config
  (scroll-bar-mode -1))

(use-package menu-bar
  :config
  (menu-bar-mode -1)
  :bind
  ([S-f10] . menu-bar-mode))

(use-package tooltip
  :defer t
  :custom
  (tooltip-mode -1))

(use-package time
  :config
  (display-time)
  :custom
  (display-time-day-and-date t)
   ;; (display-time-form-list (list 'time 'load))
  (display-time-mail-file t)
  (display-time-24hr-format t)
  (display-time-string-forms '( day " " monthname " (" dayname ") " 24-hours ":" minutes)))

(global-set-key (kbd "C-x g") 'magit-status)

;; (use-package fancy-battery
;;   :ensure t
;;   :hook
;;   (after-init . fancy-battery-mode))

(use-package font-lock+
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons
  :ensure t
  :defer t
  :config
  (setq all-the-icons-mode-icon-alist
        `(,@all-the-icons-mode-icon-alist
          (package-menu-mode all-the-icons-octicon "package" :v-adjust 0.0)
          (jabber-chat-mode all-the-icons-material "chat" :v-adjust 0.0)
          (jabber-roster-mode all-the-icons-material "contacts" :v-adjust 0.0)
          (telega-chat-mode all-the-icons-fileicon "telegram" :v-adjust 0.0
                            :face all-the-icons-blue-alt)
          (telega-root-mode all-the-icons-material "contacts" :v-adjust 0.0))))

(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy
  :ensure t
  :after ivy
  :custom
  (all-the-icons-ivy-buffer-commands '() "Don't use for buffers.")
  :config
  (all-the-icons-ivy-setup))

;; (use-package mood-line
;;   :ensure t
;;   :hook
;;   (after-init . mood-line-mode))

(use-package winner
  :config
  (winner-mode 1))

(use-package paren
  :config
  (show-paren-mode t))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode))

(use-package highlight-numbers
  :ensure t
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :ensure t
  :config (hes-mode))

;; (use-package hl-todo
;;   :ensure t
;;   :custom-face
;;   (hl-todo ((t (:inherit hl-todo :italic t))))
;;   :hook ((prog-mode . hl-todo-mode)
;;          (yaml-mode . hl-todo-mode)))

;;;;;;;;;;;;;;;;;; ponyol4
(use-package page-break-lines
  :ensure t
  :config
  (global-page-break-lines-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :ensure t
  :custom
  (rainbow-identifiers-cie-l*a*b*-lightness 80)
  (rainbow-identifiers-cie-l*a*b*-saturation 50)
  (rainbow-identifiers-choose-face-function
   #'rainbow-identifiers-cie-l*a*b*-choose-face)
  :hook
  (emacs-lisp-mode . rainbow-identifiers-mode) ; actually, turns it off
  (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode
  :ensure t
  :hook prog-mode)

;; (use-package so-long
;;   :quelpa (so-long :url "https://raw.githubusercontent.com/emacs-mirror/emacs/master/lisp/so-long.el" :fetcher url)
;;   :config (global-so-long-mode))

;; counsel-M-x can use this one
(use-package amx :ensure t :defer t)

(use-package ivy
  :ensure t
  :custom
  ;; (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-count-format "%d/%d " "Show anzu-like counter")
  (ivy-use-selectable-prompt t "Make the prompt line selectable")
  :custom-face
  (ivy-current-match ((t (:inherit 'hl-line))))
  :bind
  (:map mode-specific-map
        ("C-r" . ivy-resume))
  :config
  (ivy-mode t))

(use-package ivy-xref
  :ensure t
  :defer t
  :custom
  (xref-show-xrefs-function #'ivy-xref-show-xrefs "Use Ivy to show xrefs"))

(use-package counsel
  :ensure t
  :bind
  (([remap menu-bar-open] . counsel-tmm)
   ([remap insert-char] . counsel-unicode-char)
   ([remap isearch-forward] . counsel-grep-or-swiper)
   :map mode-specific-map
   :prefix-map counsel-prefix-map
   :prefix "c"
   ("a" . counsel-apropos)
   ("b" . counsel-bookmark)
   ("B" . counsel-bookmarked-directory)
   ("c w" . counsel-colors-web)
   ("c e" . counsel-colors-emacs)
   ("d" . counsel-dired-jump)
   ("f" . counsel-file-jump)
   ("F" . counsel-faces)
   ("g" . counsel-org-goto)
   ("h" . counsel-command-history)
   ("H" . counsel-minibuffer-history)
   ("i" . counsel-imenu)
   ("j" . counsel-find-symbol)
   ("l" . counsel-locate)
   ("L" . counsel-find-library)
   ("m" . counsel-mark-ring)
   ("o" . counsel-outline)
   ("O" . counsel-find-file-extern)
   ("p" . counsel-package)
   ("r" . counsel-recentf)
   ("s g" . counsel-grep)
   ("s r" . counsel-rg)
   ("s s" . counsel-ag)
   ("t" . counsel-org-tag)
   ("v" . counsel-set-variable)
   ("w" . counsel-wmctrl)
   :map help-map
   ("F" . counsel-describe-face))
  :custom
  (counsel-search-engines-alist
   '((google
      "http://suggestqueries.google.com/complete/search"
      "https://www.google.com/search?q="
      counsel--search-request-data-google)
     (ddg
      "https://duckduckgo.com/ac/"
      "https://duckduckgo.com/html/?q="
      counsel--search-request-data-ddg)))
  :init
  (counsel-mode))

(with-eval-after-load 'shell
  (define-key shell-mode-map (kbd "C-r") 'counsel-shell-history))

(with-eval-after-load 'eshell
  (define-key eshell-mode-map (kbd "C-r") 'counsel-esh-history))

;; Цветной промпт с коротким путем
;; (add-hook 'shell-mode-hook
;;           (lambda ()
;;             (when (get-buffer-process (current-buffer))
;;               (process-send-string
;;                (get-buffer-process (current-buffer))
;;                "PS1='\\[\\033[1;32m\\]➜\\[\\033[0m\\] \\[\\033[1;34m\\]\\W\\[\\033[0m\\] λ ▶ '"))))

;; Убираем все лишние промпты и делаем красиво
(setq org-babel-sh-prompt "\\W $ > ")
;; (setq shell-prompt-pattern "^[^#$%>\n]*[#$%>] *")
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
;; Настройка для shell который используется в org-babel
(setq shell-command-prompt-show-cwd t)

;; Увеличить размер истории
(setq comint-input-ring-size 5000)

(use-package swiper :ensure t)

(use-package counsel-web
  :defer t
  :quelpa
  (counsel-web :repo "mnewt/counsel-web" :fetcher github))

(use-package counsel-world-clock
  :ensure t
  :after counsel
  :bind
  (:map counsel-prefix-map
        ("C" .  counsel-world-clock)))

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1))

(use-package helm-make
  :defer t
  :ensure t
  :custom (helm-make-completion-method 'ivy))

(use-package isearch
  :bind
  ;; TODO: maybe get a keybinding from global map
  (:map isearch-mode-map
        ("C-h" . isearch-delete-char)))

(use-package char-fold
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp)
  :quelpa (char-fold :url "https://raw.githubusercontent.com/emacs-mirror/emacs/master/lisp/char-fold.el"
                     :fetcher url))

(use-package mb-depth
  :config
  (minibuffer-depth-indicate-mode 1))

(use-package avy
  :ensure t
  :config
  (avy-setup-default)
  :bind
  (("C-:" .   avy-goto-char-timer)
   ("C-." .   avy-goto-word-1)
   :map goto-map
   ("M-g" . avy-goto-line)
   :map search-map
   ("M-s" . avy-goto-word-1)))

(use-package avy-zap
  :ensure t
  :bind
  ([remap zap-to-char] . avy-zap-to-char))

;;;;;;;;;;;;;;;;;;;;;;;; ponyol3
(use-package ace-jump-buffer
  :ensure t
  :bind
  (:map goto-map
        ("b" . ace-jump-buffer)))

(use-package ace-window
  :ensure t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Use home row for selecting.")
  (aw-scope 'frame "Highlight only current frame.")
  :bind
  ("M-o" . ace-window))

;; (use-package link-hint
;;   :ensure t
;;   :bind
;;   (("<XF86Search>" . link-hint-open-link)
;;    ("S-<XF86Search>" . link-hint-copy-link)
;;    :map mode-specific-map
;;    :prefix-map link-hint-keymap
;;    :prefix "l"
;;    ("o" . link-hint-open-link)
;;    ("c" . link-hint-copy-link)))

(use-package ace-link
  :ensure t
  :after link-hint ; to use prefix keymap
  :bind
  (:map link-hint-keymap
        ("l" . counsel-ace-link))
  :config
  (ace-link-setup-default))

(use-package select
  :custom
  (selection-coding-system 'utf-8)
  (select-enable-clipboard t "Use the clipboard"))

;; (use-package expand-region
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "s-]") 'er/expand-region)
;;   (global-set-key (kbd "s-[") 'er/contract-region))

;; (use-package smart-region
;;   :ensure t
;;   :bind
;;   (("C-=" . smart-region)))
(use-package transient :ensure t)

(transient-define-prefix my/selection-menu ()
  "Selection menu"
  ["Selection"
   ("w" "Word" mark-word)
   ("s" "Sexp" mark-sexp)
   ("p" "Paragraph" mark-paragraph)
   ("f" "Function" mark-defun)
   ("b" "Buffer" mark-whole-buffer)])

(global-set-key (kbd "s-]") 'my/selection-menu)

(defun my/smart-expand ()
  "Smart region expansion based on context"
  (interactive)
  (cond
   ((region-active-p)
    ;; Если регион активен, расширяем
    (cond
     ((eq (char-syntax (char-after (region-beginning))) ?w)
      (mark-sexp))  ; слово -> sexp
     (t (mark-sexp)))) ; sexp -> defun
   (t
    ;; Если нет региона, начинаем с слова
    (mark-word))))

(global-set-key (kbd "C-=") 'my/smart-expand)

(use-package minimap
  :ensure t
  :config
  (global-set-key (kbd "C-x m") 'minimap-mode)
  ;; (setq minimap-window-location 'right)
  (setq minimap-window-location 'left)
  (setq minimap-always-recenter -1)
  (setq minimap-minimum-width '0)
  (setq minimap-width-fraction 0.2)
  (setq minimap-update 1)
  )

;; (use-package expand-region
;;   :ensure t
;;   :after (org)
;;   :bind
;;   (("C-=" . er/expand-region)
;;    ("C--" . er/contract-region)
;;    :map mode-specific-map
;;    :prefix-map region-prefix-map
;;    :prefix "r"
;;    ("(" . er/mark-inside-pairs)
;;    (")" . er/mark-outside-pairs)
;;    ("'" . er/mark-inside-quotes)
;;    ([34] . er/mark-outside-quotes) ; it's just a quotation mark
;;    ("o" . er/mark-org-parent)
;;    ("u" . er/mark-url)
;;    ("b" . er/mark-org-code-block)
;;    ("." . er/mark-method-call)
;;    (">" . er/mark-next-accessor)
;;    ("w" . er/mark-word)
;;    ("d" . er/mark-defun)
;;    ("e" . er/mark-email)
;;    ("," . er/mark-symbol)
;;    ("<" . er/mark-symbol-with-prefix)
;;    (";" . er/mark-comment)
;;    ("s" . er/mark-sentence)
;;    ("S" . er/mark-text-sentence)
;;    ("p" . er/mark-paragraph)
;;    ("P" . er/mark-text-paragraph)))

(use-package elec-pair
  :config
  (electric-pair-mode))

(use-package edit-indirect
  :ensure t
  :after expand-region ; to use region-prefix-map
  :bind
  (:map region-prefix-map
        ("r" . edit-indirect-region)))

(use-package clipmon
  :ensure t
  :defer 0.1
  :config
  (clipmon-mode))

;; (use-package copy-as-format
;;   :ensure t
;;   :custom
;;   (copy-as-format-default "slack" "or Telegram")
;;   :bind
;;   (:map mode-specific-map
;;         :prefix-map copy-as-format-prefix-map
;;         :prefix "f"
;;         ("f" . copy-as-format)
;;         ("a" . copy-as-format-asciidoc)
;;         ("b" . copy-as-format-bitbucket)
;;         ("d" . copy-as-format-disqus)
;;         ("g" . copy-as-format-github)
;;         ("l" . copy-as-format-gitlab)
;;         ("c" . copy-as-format-hipchat)
;;         ("h" . copy-as-format-html)
;;         ("j" . copy-as-format-jira)
;;         ("m" . copy-as-format-markdown)
;;         ("w" . copy-as-format-mediawiki)
;;         ("o" . copy-as-format-org-mode)
;;         ("p" . copy-as-format-pod)
;;         ("r" . copy-as-format-rst)
;;         ("s" . copy-as-format-slack)))

(use-package man
  :defer t
  :custom
  (Man-notify-method 'pushy "show manpage HERE")
  :custom-face
  (Man-overstrike ((t (:inherit font-lock-type-face :bold t))))
  (Man-underline ((t (:inherit font-lock-keyword-face :underline t)))))

(use-package woman
  :defer t
  :custom-face
  (woman-bold ((t (:inherit font-lock-type-face :bold t))))
  (woman-italic ((t (:inherit font-lock-keyword-face :underline t)))))

(use-package info-colors
  :ensure t
  :hook
  (Info-selection #'info-colors-fontify-node))

;; (use-package keyfreq
;;   :defer 0.1
;;   :ensure t
;;   :config
;;   (keyfreq-mode 1)
;;   (keyfreq-autosave-mode 1))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package free-keys
  :ensure t
  :defer t
  :commands free-keys)

(use-package helpful
  :ensure t
  :defer t)

;; (use-package jabber
;;   :defer t
;;   :secret
;;   (jabber-connect-all "jabber.el.gpg")
;;   :config
;;   (setq jabber-history-enabled t
;;         jabber-use-global-history nil
;;         fsm-debug nil)
;;   :custom
;;   (jabber-auto-reconnect t)
;;   (jabber-chat-buffer-format "*-jc-%n-*")
;;   (jabber-groupchat-buffer-format "*-jg-%n-*")
;;   (jabber-chat-foreign-prompt-format "▼ [%t] %n> ")
;;   (jabber-chat-local-prompt-format "▲ [%t] %n> ")
;;   (jabber-muc-colorize-foreign t)
;;   (jabber-muc-private-buffer-format "*-jmuc-priv-%g-%n-*")
;;   (jabber-rare-time-format "%e %b %Y %H:00")
;;   (jabber-resource-line-format "   %r - %s [%p]")
;;   (jabber-roster-buffer "*-jroster-*")
;;   (jabber-roster-line-format "%c %-17n")
;;   (jabber-roster-show-bindings nil)
;;   (jabber-roster-show-title nil)
;;   (jabber-roster-sort-functions (quote (jabber-roster-sort-by-status jabber-roster-sort-by-displayname jabber-roster-sort-by-group)))
;;   (jabber-show-offline-contacts nil)
;;   (jabber-show-resources nil))

;; (use-package jabber-otr
;;   :ensure t
;;   :defer t)

;; (use-package point-im
;;   :defines point-im-reply-id-add-plus
;;   :after jabber
;;   :quelpa
;;   (point-im :repo "a13/point-im.el" :fetcher github :version original)
;;   :config
;;   (setq point-im-reply-id-add-plus nil)
;;   :hook
;;   (jabber-chat-mode . point-im-mode))

;; (use-package slack
;;   :ensure t
;;   :secret
;;   (slack-start "work.el.gpg")
;;   :commands (slack-start)
;;   :custom
;;   (slack-buffer-emojify t) ;; if you want to enable emoji, default nil
;;   (slack-prefer-current-team t))

;; TODO: move somewhere
;; (use-package alert
;;   :ensure t
;;   :commands (alert)
;;   :custom
;;   (alert-default-style 'libnotify))

;;;;;;;;;;;;;;;;;;;;;;; ponyol2
(use-package shr
  :defer t
  :custom
  (shr-use-fonts nil))

(use-package shr-color
  :defer t
  :custom
  (shr-color-visible-luminance-min 80 "Improve the contrast"))

;; (use-package eww
;;   :defer t
;;   :custom
;;   (eww-search-prefix "https://duckduckgo.com/html/?kd=-1&q="))

;; (use-package browse-url
;;   :bind
;;   ([f5] . browse-url))

;; (use-package bruh
;;   :after browse-url
;;   :quelpa
;;   (bruh :repo "a13/bruh" :fetcher github)
;;   :custom-update
;;   (bruh-images-re
;;    '("^https?://img-fotki\\.yandex\\.ru/get/"
;;      "^https?://pics\\.livejournal\\.com/.*/pic/"
;;      "^https?://l-userpic\\.livejournal\\.com/"
;;      "^https?://img\\.leprosorium\\.com/[0-9]+$"))
;;   :custom
;;   (browse-url-browser-function #'bruh-browse-url)
;;   (bruh-default-browser #'bruh-chromium-new-app)
;;   (bruh-videos-browser-function #'bruh-mpv))


;; (use-package webjump
;;   :bind
;;   (([S-f5] . webjump))
;;   :config
;;   (setq webjump-sites
;;         (append '(("debian packages" .
;;                    [simple-query "packages.debian.org" "http://packages.debian.org/" ""]))
;;                 webjump-sample-sites)))

;; (use-package atomic-chrome
;;   :ensure t
;;   :custom
;;   (atomic-chrome-url-major-mode-alist
;;    '(("reddit\\.com" . markdown-mode)
;;      ("github\\.com" . gfm-mode)
;;      ("redmine" . textile-mode))
;;    "Major modes for URLs.")
;;   :config
;;   (atomic-chrome-start-server))

;; (use-package shr-tag-pre-highlight
;;   :ensure t
;;   ;;:defer t
;;   :after shr
;;   :custom-update
;;   (shr-external-rendering-functions
;;    '((pre . shr-tag-pre-highlight))))

;; (use-package google-this
;;   :ensure t
;;   :bind
;;   (:map mode-specific-map
;;         ("g" . #'google-this-mode-submap)))

;; (use-package multitran
;;   :ensure t
;;   :defer t)

;; (use-package imgbb
;;   :ensure t
;;   :defer t)

;; (use-package mu4e
;;   :defer t
;;   :load-path "/usr/share/emacs/site-lisp/mu4e"
;;   ;; let's install it now, since mu4e packages aren't available yet
;;   :ensure-system-package (mu . mu4e))

;; (use-package smtpmail
;;   :defer t
;;   :custom
;;   (smtpmail-queue-mail nil "start in normal mode")
;;   ;;set up queue for offline email
;;   (smtpmail-queue-dir "~/.mail/queue/cur" "use `mu mkdir ~/.mail/queue` to set up first"))

;; (use-package mu4e-vars
;;   :defer t
;;   :custom
;;   (mu4e-view-show-images t "enable inline images")
;;   (mu4e-maildir (expand-file-name "~/.mail/work"))
;;   (mu4e-completing-read-function 'completing-read "ivy does all the work")
;;   (mu4e-get-mail-command "mbsync work" "sync with mbsync")
;;   (mu4e-change-filenames-when-moving t "rename files when moving, needed for mbsync")
;;   :config
;;   ;; use imagemagick, if available
;;   (when (fboundp 'imagemagick-register-types)
;;     (imagemagick-register-types)))

;; (use-package mu4e-contrib
;;   :defer t
;;   :custom
;;   (mu4e-html2text-command 'mu4e-shr2text))

(use-package calendar
  :defer t
  :custom
  (calendar-week-start-day 1))

;; (use-package org
;;   :defer t
;;   ;; to be sure we have the latest Org version
;;   :ensure org-plus-contrib
;;   :hook
;;   (org-mode . variable-pitch-mode)
;;   (org-mode . visual-line-mode)
;;   :custom
;;   (org-src-tab-acts-natively t))

;; (use-package org-passwords
;;   :ensure org-plus-contrib
;;   :bind
;;   (:map org-mode-map
;;         ("C-c C-p p" . org-passwords-copy-password)
;;         ("C-c C-p u" . org-passwords-copy-username)
;;         ("C-c C-p o" . org-passwords-open-url)))

;; (use-package org-bullets
;;   :ensure t
;;   :custom
;;   ;; org-bullets-bullet-list
;;   ;; default: "◉ ○ ✸ ✿"
;;   ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
;;   ;; Small: ► • ★ ▸
;;   (org-bullets-bullet-list '("•"))
;;   ;; others: ▼, ↴, ⬎, ⤷,…, and ⋱.
;;   ;; (org-ellipsis "⤵")
;;   (org-ellipsis "…")
;;   :hook
;;   (org-mode . org-bullets-mode))

(use-package htmlize
  :defer t
  :custom
  (org-html-htmlize-output-type 'css)
  (org-html-htmlize-font-prefix "org-"))

;; (use-package org-jira
;;   :defer t
;;   :custom
;;   (jiralib-url "http://jira:8080"))

(use-package synosaurus
  :defer t
  :ensure t
  :custom
  (synosaurus-choose-method 'default)
  :config
  (synosaurus-mode))

(use-package writegood-mode
  :defer t
  :ensure t)

(use-package ibuffer-vc
  :defer t
  :ensure t
  :config
  (define-ibuffer-column icon
    (:name "Icon" :inline t)
    (all-the-icons-ivy--icon-for-mode major-mode))
  :custom
  (ibuffer-formats
   '((mark modified read-only vc-status-mini " "
           (name 18 18 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " "
           filename-and-process)) "include vc status info")
  :hook
  (ibuffer . (lambda ()
               (ibuffer-vc-set-filter-groups-by-vc-root)
               (unless (eq ibuffer-sorting-mode 'alphabetic)
                 (ibuffer-do-sort-by-alphabetic)))))

(use-package gitconfig-mode
  :ensure t
  :defer t)

(use-package gitignore-mode
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :custom
  (magit-completing-read-function 'ivy-completing-read "Force Ivy usage.")
  :bind
  (:map mode-specific-map
        :prefix-map magit-prefix-map
        :prefix "m"
        (("a" . magit-stage-file) ; the closest analog to git add
         ("b" . magit-blame)
         ("B" . magit-branch)
         ("c" . magit-checkout)
         ("C" . magit-commit)
         ("d" . magit-diff)
         ("D" . magit-discard)
         ("f" . magit-fetch)
         ("g" . vc-git-grep)
         ("G" . magit-gitignore)
         ("i" . magit-init)
         ("l" . magit-log)
         ("m" . magit)
         ("M" . magit-merge)
         ("n" . magit-notes-edit)
         ("p" . magit-pull-branch)
         ("P" . magit-push-current)
         ("r" . magit-reset)
         ("R" . magit-rebase)
         ("s" . magit-status)
         ("S" . magit-stash)
         ("t" . magit-tag)
         ("T" . magit-tag-delete)
         ("u" . magit-unstage)
         ("U" . magit-update-index))))

;; Отключаем file notifications - решает 99% проблем
(setq auto-revert-use-notify nil)

;; Небольшая задержка для перестраховки
(setq auto-revert-interval 5)

;; Опционально: если всё равно будут проблемы
;; (setq magit-auto-revert-immediately nil)

(use-package forge
  :defer t
  :after magit
  :ensure t)

(use-package git-timemachine
  :ensure t
  :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;; ponyol1
(use-package browse-at-remote
  :ensure t
  :after link-hint
  :bind
  (:map link-hint-keymap
        ("r" . browse-at-remote)
        ("k" . browse-at-remote-kill)))

(use-package smerge-mode
  :defer t)

(use-package diff-hl
  :ensure t
  :hook
  ((magit-post-refresh . diff-hl-magit-post-refresh)
   (prog-mode . diff-hl-mode)
   (org-mode . diff-hl-mode)
   (dired-mode . diff-hl-dired-mode)))

(use-package smart-comment
  :ensure t
  :bind ("M-;" . smart-comment))

(use-package ag
  :defer t
  :ensure t)

(use-package projectile
  :demand t
  :ensure t
  :init
  ;; --- ВОТ ИСПРАВЛЕНИЕ ---
  ;; Мы заранее "объявляем" эти переменные, присваивая им nil.
  ;; Теперь Emacs не будет ругаться, что они "void".
  ;; Projectile при загрузке задаст им свои значения по умолчанию.
  (defvar projectile-globally-ignored-directories nil)
  (defvar projectile-ignored-directories nil)

  ;; Теперь этот код в :init сработает, так как переменная существует
  (add-to-list 'projectile-globally-ignored-directories (expand-file-name "elpa" user-emacs-directory))
  (add-to-list 'projectile-globally-ignored-directories (expand-file-name "straight/repos" user-emacs-directory))

  :config
  ;; Этот код тоже сработает, так как переменная была объявлена
  (add-to-list 'projectile-ignored-directories ".git")
  (add-to-list 'projectile-ignored-directories ".idea")
  (add-to-list 'projectile-ignored-directories ".vscode")
  :bind
  (:map mode-specific-map ("p" . projectile-command-map))
  :custom
  (projectile-project-root-files-functions
   '(projectile-root-local
     projectile-root-top-down
     projectile-root-bottom-up
     projectile-root-top-down-recurring))
  (projectile-completion-system 'ivy))

(use-package counsel-projectile
  :ensure t
  :after counsel projectile
  :config
  (counsel-projectile-mode))

(use-package ag
  :defer t
  :ensure-system-package (ag . silversearcher-ag)
  :custom
  (ag-highlight-search t "Highlight the current search term."))

(use-package dumb-jump
  :ensure t
  :defer t
  :custom
  (dumb-jump-selector 'ivy)
  (dumb-jump-prefer-searcher 'ag))

(use-package company
  :ensure t
  :bind
  (:map company-active-map
        ("C-n" . company-select-next-or-abort)
        ("C-p" . company-select-previous-or-abort))
  :hook
  (after-init . global-company-mode))

(use-package company-quickhelp
  :ensure t
  :defer t
  :custom
  (company-quickhelp-delay 3)
  :config
  (company-quickhelp-mode 1))

(use-package company-shell
  :ensure t
  :after company
  :defer t
  :custom-update
  (company-backends '(company-shell)))

(use-package company-emoji
 :ensure t
 :after company
 :defer t
 ;; :ensure-system-package fonts-symbola
 :custom-update
 (company-backends '(company-emoji))

 :config
 (set-fontset-font t 'symbol
                  (font-spec :family
                              (if (eq system-type 'darwin)
                                  "Apple Color Emoji"
                                "Symbola"))
                   nil 'prepend))

(use-package hippie-exp
  :bind
  ([remap dabbrev-expand] . hippie-expand))

(use-package autoinsert
  :hook
  (find-file . auto-insert))

(use-package yasnippet
  :ensure t
  :custom
  (yas-prompt-functions '(yas-completing-prompt yas-ido-prompt))
  :config
  (yas-reload-all)
  :hook
  (prog-mode  . yas-minor-mode))

(use-package flycheck
  :hook
  (prog-mode . flycheck-mode))

(use-package avy-flycheck
  :defer t
  :config
  (avy-flycheck-setup))

;; (use-package lisp
;;   :hook
;;   (after-save . check-parens))

(use-package elisp-mode
  :ensure nil
  :config
  (when (and (fboundp 'preceding-sexp)
             (fboundp 'elisp--preceding-sexp))
    (defalias 'preceding-sexp #'elisp--preceding-sexp))
  :bind
  (:map emacs-lisp-mode-map
        ("C-c C-d C-d" . describe-function)
        ("C-c C-d d" . describe-function)
        ("C-c C-k" . eval-buffer)))

(setq warning-suppress-types '((bytecomp)))

(use-package highlight-defined
  :ensure t
  :custom
  (highlight-defined-face-use-itself t)
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

(use-package highlight-quoted
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-quoted-mode))

(use-package highlight-sexp
  :quelpa
  (highlight-sexp :repo "daimrod/highlight-sexp" :fetcher github :version original)
  :hook
  (clojure-mode . highlight-sexp-mode)
  (emacs-lisp-mode . highlight-sexp-mode)
  (lisp-mode . highlight-sexp-mode))

(use-package eros
  :ensure t
  :hook
  (emacs-lisp-mode . eros-mode))

(use-package suggest
  :ensure t
  :defer t)

(use-package ipretty
  :defer t
  :ensure t
  :config
  (ipretty-mode 1))

(use-package nameless
  :ensure t
  :hook
  (emacs-lisp-mode .  nameless-mode)
  :custom
  (nameless-global-aliases '())
  (nameless-private-prefix t))

;; bind-key can't bind to keymaps
(use-package erefactor
  :ensure t
  :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ponyol
(use-package flycheck-package
  :ensure t
  :defer t
  :after flycheck
  (flycheck-package-setup))

;; (use-package dash
;;   :custom
;;   (dash-enable-fontlock t))

;; (use-package geiser
;;   :ensure t
;;   :defer t)

;; (use-package clojure-mode
;;   :ensure t
;;   :defer t
;;   :config
;;   (define-clojure-indent
;;     (if-let-failed? 'defun)
;;     (if-let-ok? 'defun)
;;     (when-let-failed? 'defun)
;;     (when-let-ok? 'defun)
;;     (attempt-all 'defun)
;;     (alet 'defun)
;;     (alet 'defun)
;;     (mlet 'defun)))

;; (use-package clojure-snippets
;;   :ensure t
;;   :defer t)

;; (use-package cider
;;   :ensure t
;;   :defer t
;;   :custom
;;   (cider-repl-display-help-banner nil))

;; (use-package kibit-helper
;;   :ensure t
;;   :defer t)

;; (use-package slime
;;   :ensure t
;;   :disabled
;;   :config
;;   (setq inferior-lisp-program "/usr/bin/sbcl"
;;         lisp-indent-function 'common-lisp-indent-function
;;         slime-complete-symbol-function 'slime-fuzzy-complete-symbol
;;         slime-startup-animation nil)
;;   (slime-setup '(slime-fancy))
;;   (setq slime-net-coding-system 'utf-8-unix))

;; (use-package erlang
;;   :ensure t
;;   :defer t
;;   :custom
;;   (erlang-compile-extra-opts '(debug_info))
;;   :config
;;   (require 'erlang-start))


;; (use-package company-erlang
;;   :ensure t
;;   :hook
;;   (erlang-mode #'company-erlang-init))

;; (use-package lua-mode
;;   :ensure t
;;   :defer t)

;; (use-package conkeror-minor-mode
;;   :ensure t
;;   :disabled
;;   :defer t
;;   :hook
;;   (js-mode . (lambda ()
;;                (when (string-match "conkeror" (or (buffer-file-name) ""))
;;                  (conkeror-minor-mode 1)))))

(use-package json-mode
  :ensure t
  :defer t)

;; (use-package graphql-mode
;;   :ensure t
;;   :mode "\\.graphql\\'"
;;   :custom
;;   (graphql-url "http://localhost:8000/api/graphql/query"))

(use-package sh-script
  :mode (("zshecl" . sh-mode)
         ("\\.zsh\\'" . sh-mode))
  :custom
  ;; zsh
  (system-uses-terminfo nil))

(use-package executable
  :hook
  (after-save . executable-make-buffer-file-executable-if-script-p))

;; (use-package apt-sources-list
;;   :ensure t)

(use-package ssh-config-mode
  :ensure t
  :init
  (autoload 'ssh-config-mode "ssh-config-mode" t)
  :mode
  (("/\\.ssh/config\\'"     . ssh-config-mode)
   ("/sshd?_config\\'"      . ssh-config-mode)
   ("/known_hosts\\'"       . ssh-known-hosts-mode)
   ("/authorized_keys2?\\'" . ssh-authorized-keys-mode))
  :hook
  (ssh-config-mode . turn-on-font-lock))

;; (with-eval-after-load 'expand-region
;;   ;; Здесь размещаем код, использующий region-prefix-map
;;   (define-key region-prefix-map (kbd "r") 'markdown-function))

;; (defvar region-prefix-map nil
;;   "Dummy definition to bypass errors related to undefined region-prefix-map.")

(use-package markdown-mode
  :ensure t
  :ensure-system-package markdown
  :init
  (unless (boundp 'region-prefix-map)
    (defvar region-prefix-map (make-sparse-keymap)
      "Dummy definition to bypass errors related to undefined region-prefix-map."))
  :after expand-region
  :mode (("\\`README\\.md\\'" . markdown-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :custom
  (markdown-command "markdown"))

;; (use-package jira-markup-mode
;;   :ensure t
;;   :defer t
;;   :after atomic-chrome
;;   :mode ("\\.confluence$" . jira-markup-mode)
;;   :custom-update
;;   (atomic-chrome-url-major-mode-alist
;;    '(("atlassian\\.net$" . jira-markup-mode))))

;; (use-package csv-mode
;;   :ensure t
;;   :mode
;;   (("\\.[Cc][Ss][Vv]\\'" . csv-mode)))

;; (use-package groovy-mode
;;   :ensure t
;;   :custom
;;   (groovy-indent-offset 2))

;; (use-package jenkinsfile-mode
;;   :quelpa
;;   (jenkinsfile-mode :repo "john2x/jenkinsfile-mode" :fetcher github))

(use-package aql-mode
  :defer t
  :quelpa
  (aql-mode :repo "matthewrsilver/aql-mode" :fetcher github)
  :mode
  (("\\.arango$" . aql-mode)))

(use-package restclient
  :ensure t
  :mode
  ("\\.http\\'" . restclient-mode))

(use-package restclient-test
  :ensure t
  :hook
  (restclient-mode-hook . restclient-test-mode))

(use-package ob-restclient
  :ensure t
  :after org restclient
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t))))

(use-package company-restclient
  :ensure t
  :after (company restclient)
  :custom-update
  (company-backends '(company-restclient)))

(use-package net-utils
  :ensure-system-package traceroute
  :bind
  (:map mode-specific-map
        :prefix-map net-utils-prefix-map
        :prefix "n"
        ("p" . ping)
        ("i" . ifconfig)
        ("w" . iwconfig)
        ("n" . netstat)
        ("p" . ping)
        ("a" . arp)
        ("r" . route)
        ("h" . nslookup-host)
        ("d" . dig)
        ("s" . smbclient)
        ("t" . traceroute)))

(use-package docker
  :ensure t
  :bind
  (:map mode-specific-map
        ("D" . docker)))

;; not sure if these two should be here
(use-package dockerfile-mode
  :ensure t
  :defer t
  :mode "Dockerfile.*\\'")

(use-package docker-compose-mode
  :ensure t
  :defer t)

(use-package emamux
  :ensure t
  :defer t)

(use-package char-fold
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp))

(use-package reverse-im
  :ensure t ; install `reverse-im' using package.el
  :demand t ; always load it
  :after char-fold ; but only after `char-fold' is loaded
  :bind
  ("M-T" . reverse-im-translate-word) ; fix a word in wrong layout
  :custom
  (reverse-im-char-fold t) ; use lax matching
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-input-methods '("russian-computer" "ukrainian-computer")) ; translate these methods
  :config
  (reverse-im-mode t))

;; (use-package debian-el
;;   :ensure t
;;   :defer t)

;; (use-package unipunct
;;   :quelpa (unipunct :url "https://raw.githubusercontent.com/a13/xkb-custom/master/contrib/unipunct.el" :fetcher url))

;; (use-package reverse-im
;;   :ensure t
;;   :demand t
;;   :after unipunct char-fold
;;   :bind
;;   ("M-T" . reverse-im-translate-word)
;;   :custom
;;   (reverse-im-char-fold t)
;;   (reverse-im-read-char-advice-function #'reverse-im-read-char-exclude)
;;   (reverse-im-input-methods '("russian-unipunct"))
;;   :config
;;   (reverse-im-mode t))

(use-package sidebar
  :quelpa
  (sidebar :repo "sebastiencs/sidebar.el" :fetcher github))
;; (require 'sidebar)
;; (global-set-key (kbd "C-x C-f") 'sidebar-open)
;; (global-set-key (kbd "C-x C-a") 'sidebar-buffers-open)

(use-package dired-subtree
  :ensure t
  :commands (dired-subtree-toggle dired-subtree-cycle))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :after dired-subtree
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              ;; Убрать некоторые ограничения
              (setq-local window-size-fixed nil)))
  :config
  (setq dired-sidebar-subtree-line-prefix " .")
  (cond
   ((eq system-type 'darwin)
    (if (display-graphic-p)
        (setq dired-sidebar-theme 'icons)
      (setq dired-sidebar-theme 'nerd))
    (setq dired-sidebar-face '(:family "Helvetica" :height 150))) ;; use font
   ((eq system-type 'windows-nt)
    (setq dired-sidebar-theme 'nerd)
    (setq dired-sidebar-face '(:family "Lucida Sans Unicode" :height 150)))
   (:default
    (setq dired-sidebar-theme 'nerd)
    (setq dired-sidebar-face '(:family "Arial" :height 150))))

  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t)
  (setq dired-sidebar-resize-on-open t)
  (setq dired-sidebar-width 25)

  (use-package all-the-icons-dired
    ;; M-x all-the-icons-install-fonts
    :ensure t
    :commands (all-the-icons-dired-mode)))

;; Функции и биндинги отдельно
(defun my/dired-sidebar-set-width (width)
  "Изменить ширину dired-sidebar на WIDTH."
  (interactive "nШирина sidebar: ")
  (when-let ((window (get-buffer-window (dired-sidebar-buffer))))
    (with-selected-window window
      (let ((window-size-fixed nil))
        (window-resize window (- width (window-width)) t t)))))

(defun my/dired-sidebar-wider ()
  "Увеличить ширину sidebar на 5 колонок."
  (interactive)
  (when (get-buffer-window (dired-sidebar-buffer))
    (with-selected-window (get-buffer-window (dired-sidebar-buffer))
      (my/dired-sidebar-set-width (+ (window-width) 3)))))

(defun my/dired-sidebar-narrower ()
  "Уменьшить ширину sidebar на 5 колонок."
  (interactive)
  (when (get-buffer-window (dired-sidebar-buffer))
    (with-selected-window (get-buffer-window (dired-sidebar-buffer))
      (my/dired-sidebar-set-width (- (window-width) 3)))))

;; Биндинги
(with-eval-after-load 'dired-sidebar
  (define-key dired-sidebar-mode-map (kbd "C-c +") 'my/dired-sidebar-wider)
  (define-key dired-sidebar-mode-map (kbd "C-c -") 'my/dired-sidebar-narrower))

(global-set-key (kbd "C-c s w") 'my/dired-sidebar-set-width)

;; (setq org-id-track-globally t)
;; (use-package ejira
;;   :quelpa
;;   :init
;;   (setq jiralib2-url              "https://fintechservice.atlassian.net"
;;         jiralib2-auth             'token
;;         jiralib2-user-login-name  "o.ponomarev@kyrrex.com"
;;         jiralib2-token            "uD7laRkRVcXPGNw823JA05C7"

;;         ;; NOTE, this directory needs to be in `org-agenda-files'`
;;         ejira-org-directory       "~/jira"
;;         ejira-projects            '("NTR")

;;         ejira-priorities-alist    '(("Highest" . ?A)
;;                                     ("High"    . ?B)
;;                                     ("Medium"  . ?C)
;;                                     ("Low"     . ?D)
;;                                     ("Lowest"  . ?E))
;;         ejira-todo-states-alist   '(("To Do"       . 1)
;;                                     ("In Progress" . 2)
;;                                     ("Done"        . 3)))
;;   :config
;;   ;; Tries to auto-set custom fields by looking into /editmeta
;;   ;; of an issue and an epic.
;;   (add-hook 'jiralib2-post-login-hook #'ejira-guess-epic-sprint-fields)

;;   ;; They can also be set manually if autoconfigure is not used.
;;   ;; (setq ejira-sprint-field       'customfield_10001
;;   ;;       ejira-epic-field         'customfield_10002
;;   ;;       ejira-epic-summary-field 'customfield_10004)

;;   (require 'ejira-agenda)

;;   ;; Make the issues visisble in your agenda by adding `ejira-org-directory'
;;   ;; into your `org-agenda-files'.
;;   (add-to-list 'org-agenda-files ejira-org-directory)

;;   ;; Add an agenda view to browse the issues that
;;   (org-add-agenda-custom-command
;;    '("j" "My JIRA issues"
;;      ((ejira-jql "resolution = unresolved and assignee = currentUser()"
;;                  ((org-agenda-overriding-header "Assigned to me")))))))

;; (setq ejira-update-jql-unresolved-fn #'ejira-jql-my-unresolved-project-tickets)

(setq org-todo-keywords
  '((sequence
     "TODO(t!)" ; Initial creation
     "PROGRESS(p)"; Work in progress
     "WAIT(w)" ; My choice to pause task
     "|" ; Remaining close task
     "DONE(d)" ; Normal completion
     "CANCELED(c)" ; Not going to od it
     )))

;; (setq org-jira-keywords-to-jira-status-alist
;;   '(("To Do" . "TODO")
;;     ("In Progress" . "PROGRESS")
;;     ("Hold" . "WAIT")
;;     ("Done" . "DONE")))

(setq org-jira-jira-status-to-org-keyword-alist
  '(("To Do" . "TODO")
    ("In Progress" . "PROGRESS")
    ("Hold" . "WAIT")
    ("Done" . "DONE")
    ("Cancelled" . "CANCELED")))

;; (make-directory "~/.org-jira")
(setq jiralib-url "https://fintechservice.atlassian.net")
;; (setq jiralib-token uD7laRkRVcXPGNw823JA05C7)
;; (setq jiralib-token "uD7laRkRVcXPGNw823JA05C7")
;; (defconst org-jira-progress-issue-flow
;;   '(("To_do" . "In_Progress")
;;      ("In_Progress" . "Done")))
(defconst org-jira-progress-issue-flow
  '(("To Do" . "In Progress")
     ("In Progress" . "Done")))

(setq org-jira-custom-jqls
  '(
    (:jql " project IN (DEVOP) and assignee IN ('Oleh Ponomarov') and status NOT IN ('Done') order by id DESC, status DESC "
          :limit 30
          :filename "ponyol")
    (:jql " project IN (DEVOP) and assignee IN ('Oleh Ponomarov') and status IN ('Done') order by updated DESC "
          :limit 30
          :filename "ponyol")
    (:jql " project IN (DEVOP) and assignee IN ('Serhii Tarasov') and status NOT IN ('Done') order by id DESC, status DESC "
          :limit 30
          :filename "tarasov")
    (:jql " project IN (DEVOP) and assignee IN ('Serhii Tarasov') and status IN ('Done') order by updated DESC "
          :limit 30
          :filename "tarasov")
    (:jql " project IN (DEVOP) and assignee IN ('vladyslav chuikov') and status NOT IN ('Done') order by id DESC, status DESC "
          :limit 30
          :filename "chuikov")
    (:jql " project IN (DEVOP) and assignee IN ('vladyslav chuikov') and status IN ('Done') order by updated DESC "
          :limit 30
          :filename "chuikov")
    (:jql " project IN (DEVOP) and assignee IN ('Olha Roshchepii') and status NOT IN ('Done') order by id DESC, status DESC "
          :limit 30
          :filename "olha")
    (:jql " project IN (DEVOP) and assignee IN ('Olha Roshchepii') and status IN ('Done') order by updated DESC "
          :limit 30
          :filename "olha")
    ))

(add-to-list 'auto-mode-alist '("~/.org-jira/.*\\'" . org-jira-mode))

(global-set-key (kbd "C-c C-b") 'highlight-indent-guides-mode)
(global-set-key (kbd "C-c C-a") 'nlinum-mode)
(global-set-key (kbd "s-§") 'other-frame)

(with-eval-after-load 'highlight-indent-guides
  (setq highlight-indent-guides-auto-enabled nil)
  (setq highlight-indent-guides-face-perc 20) ;; Яркость полос
  (set-face-background 'highlight-indent-guides-odd-face "#666564")
  (set-face-background 'highlight-indent-guides-even-face "#524d48"))
;; (setq highlight-indent-guides-auto-enabled nil)
;; (setq highlight-indent-guides-face-perc 20) ;; Яркость полос
;; (set-face-background 'highlight-indent-guides-odd-face "#666564")
;; (set-face-background 'highlight-indent-guides-even-face "#524d48")

(use-package consult
  :ensure t)

(use-package writeroom-mode
  :ensure t)
(with-eval-after-load 'writeroom-mode
  (define-key writeroom-mode-map (kbd "C-M-<") #'writeroom-decrease-width)
  (define-key writeroom-mode-map (kbd "C-M->") #'writeroom-increase-width)
  (define-key writeroom-mode-map (kbd "C-M-=") #'writeroom-adjust-width))
(global-set-key (kbd "s-'") 'writeroom-mode)
(setq writeroom-restore-window-config 't)
;; Абсолютно фиксированная ширина
(setq writeroom-width 120)
;; или относительная ширина (например, 70% окна)
(setq writeroom-width 0.9)

(add-to-list 'default-frame-alist '(width . 130))   ;; ширина в символах
(add-to-list 'default-frame-alist '(height . 44))   ;; высота в строках
(add-to-list 'default-frame-alist '(left . 100))    ;; позиция X в пикселях
(add-to-list 'default-frame-alist '(top . 40))      ;; позиция Y в пикселях

(defvar my/frame-presets
  '(
    ("Left monitor"        . ((width . 120) (height . 40) (left . 0)   (top . 0)))
    ("Right monitor"       . ((width . 100) (height . 35) (left . 20) (top . 20)))
    ("Small popup"         . ((width . 80)  (height . 25) (left . 300) (top . 200)))
    )
  "Список пресетов фреймов Emacs: (название . alist параметров)")

(defun my/consult-make-frame ()
  "Выбери пресет через consult и создай фрейм."
  (interactive)
  (let* ((choices (mapcar #'car my/frame-presets))
         (selection (consult--read choices :prompt "Выбери фрейм: "))
         (params (cdr (assoc selection my/frame-presets))))
    (make-frame params)))

;; (defun my/generate-auto-frame-name ()
;;   "Сгенерировать имя по умолчанию для нового фрейма."
;;   (format "Frame-%s" (format-time-string "%H%M%S")))

;; (defun my/consult-make-frame ()
;;   "Выбери пресет, задай имя фрейму, создай фрейм и установи имя."
;;   (interactive)
;;   (let* ((choices (mapcar #'car my/frame-presets))
;;          (selection (consult--read choices :prompt "Выбери фрейм: "))
;;          (params (cdr (assoc selection my/frame-presets)))
;;          ;; name запрашиваем до make-frame
;;          (name (read-string "Имя для фрейма (Enter — автоген): "))
;;          ;; создаём фрейм
;;          (frame (make-frame params)))
;;     ;; защищённое имя (строка)
;;     (let ((safe-name (if (stringp name) name (format "%s" name))))
;;       (with-selected-frame frame
;;         (set-frame-name
;;          (if (string-empty-p safe-name)
;;              (my/generate-auto-frame-name)
;;            safe-name)))
;;       (select-frame-set-input-focus frame))))

;; F1 → наш кастомный фрейм (было C-x 5 2)
;; (global-set-key (kbd "<f1>") #'make-frame)
(global-set-key (kbd "<f1>") #'my/consult-make-frame)
;; F2 → закрытие текущего фрейма (аналог C-x 5 0)
(global-set-key (kbd "C-x <f1>") #'delete-frame)

(use-package undo-fu
  :ensure t)

(use-package undo-fu-session
  :ensure t
  :after undo-fu
  :config
  (undo-fu-session-global-mode))

;; Если хочешь явно задать путь:
(setq undo-fu-session-directory "~/tmp/undo-history/")
(make-directory undo-fu-session-directory t)

(defun my/clear-undo-history ()
  "Удалить все сохранённые undo-файлы."
  (interactive)
  (let ((dir undo-fu-session-directory))
    (when (yes-or-no-p (format "Удалить все undo-файлы в %s?" dir))
      (delete-directory dir t)
      (make-directory dir t)
      (message "История undo очищена."))))

(defun my/resolve-real-path (path)
  "Приводит симлинк-путь в PATH к реальному, убирая a13/ и заменяя на домашний путь."
  (replace-regexp-in-string "^/Users/ponyol/a13" "/Users/ponyol" path))

(defun my/clear-current-file-undo-history ()
  "Удалить undo-историю текущего файла, заменяя симлинк-префиксы вручную."
  (interactive)
  (require 'undo-fu-session)
  (when buffer-file-name
    (let* ((real-path (my/resolve-real-path buffer-file-name))
           (file (undo-fu-session--make-file-name real-path)))
      (if (file-exists-p file)
          (progn
            (delete-file file)
            (message "✅ Undo-история удалена: %s" file))
        (message "⚠️ Undo-история не найдена: %s" file)))))

;; (message "Buffer: %s" buffer-file-name)
;; (message "Undo directory: %s" undo-fu-session-directory)
(global-set-key (kbd "<f12>") #'my/clear-current-file-undo-history)
(global-set-key (kbd "C-x <f12>") #'my/clear-undo-history)

(setq undo-limit        10000000)  ;; 10 MB обычный лимит
(setq undo-strong-limit 30000000)  ;; 50 MB при активном редактировании
(setq undo-outer-limit  50000000) ;; 200 MB максимум перед очисткой

;; (message "Undo-файл: %s"
;;          (undo-fu-session-make-file-name buffer-file-name undo-fu-session-directory))

;; (setq dired-listing-switches "-la")
;; (setq dired-omit-files "^\\...*")

;; (global-set-key (kbd "C-x ;") 'comment-region)
;; (global-set-key (kbd "C-x :") 'uncomment-region)

(defun create-scratch-buffer nil
       "create a scratch buffer"
       (interactive)
       (switch-to-buffer (get-buffer-create "*scratch*"))
;;       (lisp-interaction-mode))
       (text-mode))

(setq tramp-default-method "ssh")

;; (require 'shellcheck)
(setq org-src-fontify-natively 't)
(setq org-confirm-babel-evaluate nil)

(require 'ob-shell)
(require 'ob-python)
(require 'ob-clojure)
(require 'ob-perl)
(require 'ob-dot)
(require 'ob-R)
(require 'ob-gnuplot)
(require 'ob-lisp)
(require 'ob-org)
(require 'ob-screen)
(require 'ob-calc)
(require 'ob-js)
(require 'ob-latex)
(require 'ob-plantuml)
;;(require 'ob-sh)
(require 'ob-ditaa)
(require 'ob-awk)
(require 'ob-octave)
;;(require 'ob-json)
(require 'ob-sql)
(require 'ob-sqlite)
(require 'org-tempo)

(setq my-structure-template-alist
        '(("py" . "src python :results output")
          ("trf" . "src terraform :noweb yes :exports none :mkdirp yes :tangle ")
          ("tf" . "src terraform :noweb-ref ")
          ("el" . "src emacs-lisp")
          ("hs" . "src haskell")
          ("laeq" . "latex \n\\begin{equation} \\label{eq-sinh}\ny=\\sinh x\n\\end{equation}")
          ("sh" . "src sh")
          ("r" . "src R")
          ("js" . "src js")
          ("http" . "src http")
          ("ditaa" . "src ditaa :file")
          ("dot" . "src dot :file")
          ("rp" . "src R :results output graphics :file ")
          ("plantuml" . "src plantuml :file")
          ))
(dolist (ele my-structure-template-alist)
   (add-to-list 'org-structure-template-alist ele))

;; Keyword expansion also changed in 9.2
  (setq my-tempo-keywords-alist
        '(("n" . "NAME")
          ("cap" . "CAPTION")))

  ;; (when (version< (org-version) "9.2")
  ;;   (add-to-list 'org-modules 'org-tempo))
  ;; (require 'org-tempo)
  ;; (if (version<  (org-version) "9.2")
  ;;     (dolist (ele old-structure-template-alist)
  ;;       (add-to-list 'org-structure-template-alist ele))
  ;;   (dolist (ele new-structure-template-alist)
  ;;     (add-to-list 'org-structure-template-alist ele))
  ;;   (dolist (ele my-tempo-keywords-alist)
  ;;     (add-to-list 'org-tempo-keywords-alist ele))
  ;;   )

;; Добавляем поддержку babashka как отдельного языка
(add-to-list 'org-babel-load-languages '(babashka . t))

;; Указываем, что для блоков babashka нужно использовать babashka
(setq org-babel-babashka-command "bb")

;; Устанавливаем, что babashka будет использовать тот же режим, что и clojure
(defalias 'org-babel-execute:babashka 'org-babel-execute:clojure)

;; Опционально: если хотите, чтобы обычный clojure выполнялся через babashka тоже
;; (setq org-babel-clojure-backend 'babashka)

(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

(eval-after-load "org"
  '(require 'ox-gfm nil t))

(use-package ob-tmux
  ;; Install package automatically (optional)
  :ensure t
  :custom
  (org-babel-default-header-args:tmux
   '((:results . "silent")	;
     (:session . "default")	; The default tmux session to send code to
     (:socket  . nil)))		; The default tmux socket to communicate with
  ;; The tmux sessions are prefixed with the following string.
  ;; You can customize this if you like.
  (org-babel-tmux-session-prefix "ob-")
  ;; The terminal that will be used.
  ;; You can also customize the options passed to the terminal.
  ;; The default terminal is "gnome-terminal" with options "--".
  (org-babel-tmux-terminal "hyper")
  (org-babel-tmux-terminal-opts '("-T" "ob-tmux" "-e"))
  ;; Finally, if your tmux is not in your $PATH for whatever reason, you
  ;; may set the path to the tmux binary as follows:
  (org-babel-tmux-location "/usr/local/bin/tmux"))

(pdf-loader-install)

(require 'google-translate)
(require 'google-translate-smooth-ui)
(setq google-translate-translation-directions-alist
      '(("en" . "ru") ("ru" . "en")))

;; (global-set-key "\C-ct" (lambda ()
;;                        (setq google-translate-output-destination 'popup)
;;                        (interactive)
;;                        (google-translate-smooth-translate)))
;; (global-set-key "\C-cT" (lambda ()
;;                        (setq google-translate-output-destination 'nil)
;;                        (interactive)
;;                        (google-translate-smooth-translate)))
(global-set-key "\C-ct"
                (lambda ()
                  (interactive)
                  (let ((google-translate-output-destination 'popup))
                    (call-interactively #'google-translate-smooth-translate))))
(global-set-key "\C-cT"
                (lambda ()
                  (interactive)
                  (let ((google-translate-output-destination 'nil))
                    (call-interactively #'google-translate-smooth-translate))))

;;(setq google-translate-output-destination 'echo-area)
(setq google-translate-pop-up-buffer-set-focus 't)
;;(setq google-translate-enable-ido-completion 't)
(setq google-translate-show-phonetic 'nil)
(setq max-mini-window-height 0.5)

;; macro
(global-set-key [f2] 'kmacro-call-macro)
(global-set-key [f3] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f4] 'kmacro-end-or-call-macro)

(global-set-key [?\s-,] 'previous-buffer)
(global-set-key [?\s-.] 'next-buffer)

;; bookmak
(global-set-key [f5] 'bookmark-set)
(global-set-key [f6] 'bookmark-jump)
(global-set-key [f7] 'bookmark-bmenu-list)
(global-set-key [f8] 'bookmark-save)

(display-time)

;;(set-face-attribute 'default nil :font "Terminus-12")
(setq file-name-coding-system 'utf-8)

(setq scroll-step 1)
(global-hl-line-mode 1)
(windmove-default-keybindings 'meta)
(fset 'yes-or-no-p 'y-or-n-p)
;;(cfg:reverse-input-method 'russian-computer)

;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(setq plantuml-jar-path "~/esenti/plantuml-1.2022.5.jar")
(setq plantuml-default-exec-mode 'jar)
(setq org-plantuml-jar-path
      (expand-file-name "~/esenti/plantuml-1.2022.5.jar"))
(require 'plantuml-mode)
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)
   (python . t)
   (table . t)
   (clojure . t)
   (makefile . t)
   (eshell . t)
   (lisp . t)
   (shell . t)
   (emacs-lisp . t)
   ))

(use-package company-org-block
  :ensure t
  :custom
  (company-org-block-edit-style 'auto) ;; 'auto, 'prompt, or 'inline
  :hook ((org-mode . (lambda ()
                       (setq-local company-backends '(company-org-block))
                       (company-mode +1)))))

(require 'powerline)
(powerline-default-theme)

(set-face-attribute 'default nil :height 160)

(defun eshell/clear ()
  "clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; (define-key eshell-mode-map "\C-k" 'eshell/clear)
(setq shell-file-name "bash")

;; (use-package go-mode
;;   :mode "\\*\\.go"
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
;;   (add-hook 'go-mode-hook
;;     (lambda ()
;;       (flycheck-mode)
;; 	  (add-hook 'before-save-hook
;;                 'gofmt-before-save)
;;       (setq gofmt-command "goimports")
;; 	  (setq exec-path (append exec-path '("/Users/ponyol/go/bin/")))
;; 	  (use-package go-guru
;; 	    :config (go-guru-hl-identifier-mode))
;; 	  (use-package company-go
;; 	    :config (set (make-local-variable 'company-backends)
;; 			   '(company-go))
;; 		(company-mode))
;;       (use-package go-tag :ensure t)
;;       (use-package go-add-tags :ensure t)
;;       (use-package go-playground :ensure t)
;;       (use-package go-rename :ensure t)
;;       (use-package go-stacktracer :ensure t)
;;       (use-package gore-mode :ensure t)
;;       (use-package go-rename :ensure t)
;;       (use-package gorepl-mode
;;         :ensure t
;;         :config
;;         (add-hook 'go-mode-hook #'gorepl-mode))
;; 	  (use-package gotest
;; 	    :bind (("C-c , m" . go-test-current-file)
;;                ("C-c , s" . go-test-current-test)
;; 			   ("C-c , a" . go-test-current-project))))))

;; (setq exec-path (append exec-path '("/Users/ponyol/go/bin/")))

;; (use-package multi-compile
;;   :ensure t
;;   :config
;;   (setq multi-compile-alist '(
;;     (go-mode . (
;; ("go-build" "go build -v"
;;    (locate-dominating-file buffer-file-name ".git"))
;; ("go-build-and-run" "go build -v && echo 'build finish' && eval ./${PWD##*/}"
;;    (multi-compile-locate-file-dir ".git"))))
;;     )))

;; (setq eshell-prompt-function
;;       (lambda nil
;;         (concat
;;          (propertize (eshell/pwd))
;;          ;; (propertize "❯" 'face '(:foreground "#f75f5f"))
;;          ;; (propertize "❯" 'face '(:foreground "#ffaf5f"))
;;          ;; (propertize "❯" 'face '(:foreground "#87af5f"))
;;          (propertize " " 'face nil))))

;; (use-package python-mode
;;   :ensure t
;;   :mode ("\\.py\\'" . python-mode)
;;   :init(add-hook 'python-mode-hook #'elpy-enable)
;;   :config
;;   (setq
;;     python-shell-interpreter "python3"
;;     python-shell-interpreter-args "-i")
;; ;;    python-shell-interpreter-args "-i --simple-prompt")
;;   (use-package elpy
;;     :ensure t
;;     :bind
;;     ("M-," . elpy-goto-definition)
;;     ;; (:map elpy-mode-map
;;     ;;       ("C-M-n" . elpy-nav-forward-block)
;;     ;;       ("C-M-p" . elpy-nav-backward-block))
;;     ;; :hook ((elpy-mode . flycheck-mode)
;;     ;;        (pyenv-mode . elpy-rpc-restart))
;;     :init
;;     (elpy-enable)
;;     (defalias 'workon 'pyvenv-workon)
;;     :config
;;     (add-to-list 'company-backends 'elpy-company-backend)
;;     (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;     ; fix for MacOS, see https://github.com/jorgenschaefer/elpy/issues/1550
;;     (setq elpy-shell-echo-output nil)
;;     (setq elpy-rpc-python-command "python3")
;;     (setq elpy-rpc-timeout 2)
;;     (elpy-enable))
;;   (use-package py-autopep8
;;     :ensure t
;;     :hook
;;     (python-mode . py-autopep8-enable-on-save))
;;   (use-package py-isort
;;     :ensure t
;;     :init
;;     (add-hook 'before-save-hook #'py-isort-before-save)))

;; (use-package
;;   company-anaconda
;;   :ensure t
;;   :init (add-to-list 'company-backends 'company-anaconda))

;; (use-package
;;     anaconda-mode
;;   :ensure t
;;   :commands anaconda-mode
;;   :diminish anaconda-mode
;;   :init (progn (add-hook 'python-mode-hook 'anaconda-mode)
;;                (add-hook 'python-mode-hook 'eldoc-mode)))

;; (use-package org-sidebar
;;   :quelpa (org-sidebar :fetcher github :repo "alphapapa/org-sidebar"))

(use-package ox-ssh
  :quelpa (ox-ssh :fetcher github :repo "dantecatalfamo/ox-ssh"))

;; (use-package perspective
;;   :config
;;   (persp-mode))

;; (require 'perspective)
;; (persp-mode 1)

;; (require 'workgroups2)
;(workgroups-mode 1)

(use-package vundo
  :commands (vundo)

  ;; :straight (vundo :type git :host github :repo "casouri/vundo")
  :bind
  ("M-," . vundo)

  :config
  ;; Take less on-screen space.
  (setq vundo-compact-display t)

  ;; Better contrasting highlight.
  (custom-set-faces
    '(vundo-node ((t (:foreground "#808080"))))
    '(vundo-stem ((t (:foreground "#808080"))))
    '(vundo-highlight ((t (:foreground "#FFFF00")))))

  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
  ;; (define-key vundo-mode-map (kbd "l") #'vundo-forward)
  ;; (define-key vundo-mode-map (kbd "<right>") #'vundo-forward)
  ;; (define-key vundo-mode-map (kbd "h") #'vundo-backward)
  ;; (define-key vundo-mode-map (kbd "<left>") #'vundo-backward)
  ;; (define-key vundo-mode-map (kbd "j") #'vundo-next)
  ;; (define-key vundo-mode-map (kbd "<down>") #'vundo-next)
  ;; (define-key vundo-mode-map (kbd "k") #'vundo-previous)
  ;; (define-key vundo-mode-map (kbd "<up>") #'vundo-previous)
  ;; (define-key vundo-mode-map (kbd "<home>") #'vundo-stem-root)
  ;; (define-key vundo-mode-map (kbd "<end>") #'vundo-stem-end)
  ;; (define-key vundo-mode-map (kbd "q") #'vundo-quit)
  ;; (define-key vundo-mode-map (kbd "C-g") #'vundo-quit)
  ;; (define-key vundo-mode-map (kbd "RET") #'vundo-confirm)
  )

;; (with-eval-after-load 'evil (evil-define-key 'normal 'global (kbd "C-M-u") 'vundo))

(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Clean code folding via Outline minor mode.
;; (add-hook 'prog-mode-hook 'outline-minor-mode)
;; (add-hook 'text-mode-hook 'outline-minor-mode)

;; Show all headings but no content in Outline mode.
;; (add-hook 'outline-minor-mode-hook
;;           (defun baba/outline-overview ()
;;             "Show only outline headings."
;;             (outline-show-all)
;;             (outline-hide-body)))

;; Tab to "zoom in" on a function, backtab to "zoom out" to the outline.
(defun ponyol/outline-overview ()
  "Show only outline headings."
  (interactive)
   (outline-show-all)
   (outline-hide-body)
   )

(global-set-key (kbd "M-<tab>") 'outline-show-all)
(global-set-key (kbd "C-<tab>") 'ponyol/outline-overview)

(set-display-table-slot
 standard-display-table
 'selective-display
 (let ((face-offset (* (face-id 'shadow) (lsh 1 22))))
   (vconcat (mapcar (lambda (c) (+ face-offset c)) " |+++++>"))))

;; (require 'gitlab-ci-mode)
;; (add-to-list 'auto-mode-alist '(".gitlab-ci.*\\'" . gitlab-ci-mode))
;; (add-to-list 'auto-mode-alist '(".*ci.*\\'" . gitlab-ci-mode))

(use-package gitlab-ci-mode
  :ensure t
  :mode ((".gitlab-ci.*\\'" . gitlab-ci-mode)
         (".*ci.*\\'" . gitlab-ci-mode)
         )
  :hook
  (gitlab-ci-mode . gitlab-ci-mode-outline-hook)
  :init
  (defun gitlab-ci-mode-outline-hook ()
    (setq outline-minor-mode-cycle t)
    (setq outline-regexp "^\\(#\\{3,\\} \\)")
    (outline-minor-mode)
    (outline-show-all)
    (outline-hide-body)
    )
  )

(use-package hcl-mode
  :ensure t
  :mode (".hcl$")
  :hook
  (hcl-mode . hcl-mode-outline-hook)
  :init
  (custom-set-variables
   '(hcl-indent-level 4))
  (defun hcl-mode-outline-hook ()
    (setq outline-minor-mode-cycle t)
    (setq outline-regexp (rx
                        (or "job" "  constraint" "  update" "  group" "    task" "      env" "      config" "      service" "    network" "      dns" "    restart" "    ephemeral_disk" "        auth" "      artifact" "      template" "      logs" "      resources" "        check")
                        (one-or-more (not "{"))
                        "{"
                        line-end))
    (outline-minor-mode)
    (outline-show-all)
    (outline-hide-body)
    (define-key hcl-mode-map [tab] 'outline-cycle)
    (define-key outline-minor-mode-map [S-tab] 'indent-for-tab-command)
    )
  )

(use-package terraform-mode
  :ensure t
  :mode (".tf$")
  :hook
  (terraform-mode . terraform-mode-outline-hook)
  :init
  (custom-set-variables
    '(terraform-indent-level 4))
  (defun terraform-mode-outline-hook ()
    (setq outline-minor-mode-cycle t)
    (setq outline-regexp (rx
                        (or "###" "resource" "data" "provider" "module" "variable" "output" "locals" "terraform" "   ingress" "  default_action" "  health_check" "    redirect" "  stickiness" "  action" "  condition" "    http_header" "    source_ip" "    fixed_response" "  origin" "    custom_origin_config" "    custom_header" "  custom_error_response" "  default_cache_behavior" "    forwarded_values" "      cookies" "    function_association" "  ordered_cache_behavior" "  restrictions" "    geo_restriction" "  viewer_certificate" "  lifecycle" "  versioning" "  cors_rule" "  website" "  tags =" "  required_providers" "  backend")
                        (one-or-more (not "{"))
                        "{"
                        line-end))
    (defun terraform-outline-level () 1)
    (setq outline-level 'terraform-outline-level)
    (outline-minor-mode)
    (outline-show-all)
    (outline-hide-body)
    (define-key terraform-mode-map [tab] 'outline-cycle)
    (define-key outline-minor-mode-map [S-tab] 'indent-for-tab-command)
    )
  )

(use-package yaml-mode
 :mode "\\.ya?ml\\'"
 ;; :bind (:map yaml-mode-map
 ;;        ("M--" . hs-hide-all)
 ;;        ("M-[" . hs-show-block)
 ;;        ("M-]" . hs-hide-block))
 ;; :hook (
 ;;        ;; (yaml-mode . yafolding-mode)
 ;;        (yaml-mode . yaml-folding-mode)
 ;;        ;; (yaml-mode . hs-minor-mode)
 ;;        )
 )

(define-derived-mode yaml-folding-mode yaml-mode "YAML-Fold"
  "Major mode for editing YAML files with folding capabilities."

  ;; Определяем регулярное выражение для заголовков
  (setq-local outline-regexp "^\\( *\\)[^# \n]")

  ;; Функция определения уровня заголовка на основе отступов
  (setq-local outline-level
              (lambda ()
                (let ((indent (length (match-string 1))))
                  (if (= indent 0) 1 (+ 1 (/ indent 2))))))

  ;; Включаем outline minor mode
  (outline-minor-mode 1)

  ;; Настройка отображения свёрнутых блоков
  (set-display-table-slot standard-display-table
                         'selective-display
                         (string-to-vector " ▶ "))

  ;; Настраиваем клавиатурные сокращения
  (define-key yaml-folding-mode-map (kbd "TAB") 'outline-cycle)
  (define-key yaml-folding-mode-map (kbd "M-]") 'outline-hide-entry)
  (define-key yaml-folding-mode-map (kbd "M-[") 'outline-show-entry)

  ;; Добавляем клавиши для полного сворачивания/разворачивания
  ;; (define-key yaml-folding-mode-map (kbd "C-TAB") 'yaml-folding-hide-all)
  (define-key yaml-folding-mode-map (kbd "C-c C-f") 'yaml-folding-hide-all)
  (define-key yaml-folding-mode-map (kbd "C-c C-s") 'yaml-folding-show-all))

;; Функция полного сворачивания
(defun yaml-folding-hide-all ()
  "Свернуть все блоки в YAML документе."
  (interactive)
  (save-excursion
    ;; Сначала показываем всё
    (outline-show-all)
    ;; Идём по буферу
    (goto-char (point-min))
    (while (not (eobp))
      (when (looking-at outline-regexp)
        ;; Сворачиваем текущий entry
        (outline-hide-subtree))
      (forward-line 1))))

;; Функция полного разворачивания
(defun yaml-folding-show-all ()
  "Развернуть все блоки в YAML документе."
  (interactive)
  (outline-show-all))

;; Автоматически включаем режим для .yml и .yaml файлов
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-folding-mode))

;; Добавляем поддержку отображения символов
(font-lock-add-keywords
 'yaml-folding-mode
 '(("^[[:space:]]*\\(.*?\\):" 1 'org-level-1)
   ("^[[:space:]]*#.*" . 'font-lock-comment-face)))

;; Настройка отображения эллипсиса для свёрнутого содержимого
(set-display-table-slot standard-display-table
                       'selective-display
                       (string-to-vector " ▶ "))

(use-package clojure-mode
  :ensure t
  :defer t
  :config
  (define-clojure-indent
    (p/timer 1)
    (pdoseq 1)
    (pfor 1)
    (if-let-failed? 'defun)
    (if-let-ok? 'defun)
    (when-let-failed? 'defun)
    (when-failed 'defun)
    (when-let-ok? 'defun)
    (attempt-all 'defun)
    (alet 'defun)
    (mlet 'defun)))

(use-package clj-refactor
  :hook
  (clojure-mode . clj-refactor-mode)
  :defer t
  :ensure t)

(use-package anakondo
  :ensure t
  :hook
  (clojure-mode . anakondo-minor-mode)
  (clojurescript-mode . anakondo-minor-mode)
  (clojurec-mode . anakondo-minor-mode))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-snippets
  :ensure t
  :defer t)

(use-package cider
  :ensure t
  :defer t
  :custom
  (cider-comment-prefix "(comment \n")
  (cider-comment-continued-prefix "  ")
  (cider-comment-postfix "  \n)")
  ;; (cider-jack-in-default 'babashka)
  (cider-repl-display-help-banner nil))

(use-package kibit-helper
  :ensure t
  :defer t)

(setq org-babel-clojure-backend 'cider)
;; (setq org-babel-python-command "python3")
(setq org-babel-python-command "/Users/ponyol/.venv/bin/python3")

;; (defun turn-on-hideshow ()
;;   (hs-minor-mode 1)
;;   )
;; (add-hook 'python-mode-hook 'turn-on-hideshow)
(use-package hs-minor-mode
  :defer 2
  :hook python-mode
  :bind
    (
    ("M--" . #'hs-hide-all)
    ("M-[" . #'hs-show-block)
    ("M-]" . #'hs-hide-block)
    ))

;; (use-package highlight-indent-guides
;;   :ensure t
;;   :defer t
;;   :custom
;;     (highlight-indent-guides-suppress-auto-error t)
;;     (highlight-indent-guides-auto-odd-face-perc 40)
;;     (highlight-indent-guides-method 'fill))

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

(setq-default xref-search-program 'ugrep)
(setq-default grep-template "ugrep --color=always -0Iinr -e <R>")
(setq action-lock-switch-default '("{ }" "{○}" "{◔}" "{◑}" "{◕}" "{●}"))

(defmacro require-soft (name &rest body)
  `(if (require ,name nil t)
       (progn ,@body)
     (message "Could not load \"%s\", skipping..." ,name)))
(put 'require-soft 'lisp-indent-hook 1)

(require-soft 'orgalist
  (setq orgalist-separated-items nil)
  (define-key orgalist-mode-map (kbd "M-<left>") nil)
  (define-key orgalist-mode-map (kbd "M-<right>") nil)
  (define-key orgalist-mode-map (kbd "S-<up>") orgalist--maybe-move-up)
  (define-key orgalist-mode-map (kbd "S-<down>") orgalist--maybe-move-down)
  (define-key orgalist-mode-map (kbd "S-<left>") orgalist--maybe-outdent-tree)
  (define-key orgalist-mode-map (kbd "S-<right>") orgalist--maybe-indent-tree))

(require-soft 'howm
  ;; Directory configuration
  (setq howm-home-directory "~/GD/howm/")
  (setq howm-directory "~/GD/howm/")
  (setq howm-keyword-file (expand-file-name ".howm-keys" howm-home-directory))
  (setq howm-history-file (expand-file-name ".howm-history" howm-home-directory))
  (setq howm-file-name-format "%Y/%m/%Y-%m-%dT%H-%M-%S.md")

  ;; Use ripgrep as grep
  (setq howm-view-use-grep t)
  (setq howm-view-grep-command "rg")
  (setq howm-view-grep-option "-nH --no-heading --color never")
  (setq howm-view-grep-extended-option nil)
  (setq howm-view-grep-fixed-option "-F")
  (setq howm-view-grep-expr-option nil)
  (setq howm-view-grep-file-stdin-option nil)

  ;; counsel-rg for howm
  (require-soft 'counsel
    (defun howm-list--counsel-rg (match)
      (if (string= match "")
          (howm-list-all)
        (if (or (null ivy--old-cands)
                (equal ivy--old-cands '("No matches found")))
            (message "No match")
          (let ((howm-view-use-grep
                 #'(lambda (str file-list &optional fixed-p force-case-fold)
                     (mapcar
                      (lambda (cand)
                        (if (string-match "\\`\\(.*\\):\\([0-9]+\\):\\(.*\\)\\'" cand)
                            (let ((file (match-string-no-properties 1 cand))
                                  (line (match-string-no-properties 2 cand))
                                  (match-line (match-string-no-properties 3 cand)))
                              (list (expand-file-name file howm-directory)
                                    (string-to-number line)
                                    match-line))))
                      ivy--old-cands))))
            (howm-search ivy--old-re t)
            (riffle-set-place
             (1+ (cl-position match ivy--old-cands :test 'string=)))))))

    (defun howm-counsel-rg ()
      "Interactively grep for a string in your howm notes using rg."
      (interactive)
      (let ((default-directory howm-directory)
            (counsel-ag-command (cons (car counsel-rg-base-command)
                                      (cons "--glob=!*~"
                                            (cdr counsel-rg-base-command)))))
        (ivy-read "Search all (rg): "
                  #'counsel-ag-function
                  :dynamic-collection t
                  :keymap counsel-ag-map
                  :action #'howm-list--counsel-rg
                  :require-match t
                  :caller 'counsel-rg)))

    (define-key global-map (concat howm-prefix "r") 'howm-counsel-rg))

  ;; Default recent to sorting by mtime
  (advice-add 'howm-list-recent :after #'howm-view-sort-by-mtime)
  ;; Default all to sorting by creation, newest first
  (advice-add 'howm-list-all :after #'(lambda () (howm-view-sort-by-date t)))

  ;; Prefix title by <<< when creating new entry from a selection
  ;; 03sep2023  +leah+
  (advice-add 'howm-create-default-title-content :filter-return
              #'(lambda (t-c)
                  (cons (if (and (car t-c) (not (string= (car t-c) "")))
                            (concat "<<< " (car t-c))
                          (car t-c))
                        (cdr t-c))))

  ;; 16apr2022  +leah+
  (defun howm-menu-format-title (item &optional list-format)
    "Format matches by the title of the note.

Can be used for (howm-menu-search ... howm-menu-format-title t)."
    (let* ((info (file-name-sans-extension (howm-view-item-basename item)))
           (line (or (car (howm-item-titles item))
                     (howm-view-item-summary item))))
      (howm-menu-list-format info line item list-format)))

  ;; Rename buffers to their title
  (add-hook 'howm-mode-hook 'howm-mode-set-buffer-name)
  (add-hook 'after-save-hook 'howm-mode-set-buffer-name)

  ;; Use orgalist-mode
  ;; (require-soft 'orgalist
  ;;   (add-hook 'howm-mode-hook 'orgalist-mode))

  ;; Backspace is ok, but don't bind C-h.
  (define-key howm-menu-mode-map "\C-h" nil)
  (define-key riffle-summary-mode-map "\C-h" nil)
  (define-key howm-view-contents-mode-map "\C-h" nil)

  ;; Custom URLs
  ;; zotero://
  (add-to-list 'action-lock-default-rules
               (list "\\<zotero://\\S +" (lambda (&optional dummy)
                                           (browse-url (match-string-no-properties 0)))))
  ;; @bibtex
  (add-to-list 'action-lock-default-rules
               (list "\\s-\\(@\\([a-zA-Z0-9:-]+\\)\\)\\>"
                     (lambda (&optional dummy)
                       (browse-url (concat "zotero://select/items/bbt:"
                                           (match-string-no-properties 2))))
                     1))
  ;; make wiki-links jump to single title hit if possible
  (add-to-list 'action-lock-default-rules
               (list howm-wiki-regexp
                     (lambda (&optional dummy)
                       (let ((s (match-string-no-properties howm-wiki-regexp-pos)))
                         ;; letting create-p be nil here, howm-keyword-search-subr
                         ;; should check create-p after open-unique-p
                         (howm-keyword-search (concat "= " s) nil t)))
                     howm-wiki-regexp-hilit-pos))

  ;; Right-click in howmS to jump to file
  (defun howm-view-summary-at-mouse (e)
    (interactive "e")
    (mouse-set-point e)
    (riffle-summary-check t)
    (howm-view-summary-open t))
  (define-key howm-view-summary-mode-map [mouse-3] #'howm-view-summary-at-mouse)
  )

;; (setq telega-server-libs-prefix "/opt/homebrew/Cellar/tdlib/HEAD-07c1d53")

(setq-local face-remapping-alist '((default (:height 1.0) variable-pitch)
                                  (header-line (:height 1.3) variable-pitch)
                                  (org-document-title (:height 1.35) org-document-title)
                                  (org-code (:height 1.25) org-code)
                                  (org-verbatim (:height 1.2) org-verbatim)
                                  (org-block (:height 1.15) org-block)
                                  (org-block-begin-line (:height 1.1) org-block)))
;; (use-package org-modern
;;   :config
;;   (setq
;;    org-auto-align-tags t
;;    org-tags-column 0
;;    org-fold-catch-invisible-edits 'show-and-error
;;    org-special-ctrl-a/e t
;;    org-insert-heading-respect-content t

;;    ;; Don't style the following
;;    org-modern-tag nil
;;    org-modern-priority nil
;;    org-modern-todo nil
;;    org-modern-table nil

;;    ;; Agenda styling
;;    org-agenda-tags-column 0
;;    org-agenda-block-separator ?─
;;    org-agenda-time-grid
;;    '((daily today require-timed)
;; 	 (800 1000 1200 1400 1600 1800 2000)
;; 	 " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
;;    org-agenda-current-time-string
;;    "⭠ now ─────────────────────────────────────────────────")

;;   (global-org-modern-mode))

;; (use-package pdf-tools
;;   :ensure t
;;   :config
;;   (setenv "PKG_CONFIG_PATH" "/usr/local/Cellar/zlib/1.3.1/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/X11/lib/pkgconfig:/usr/local/Cellar/poppler/24.12.0/lib/pkgconfig:/opt/X11/share/pkgconfig")
;;   (pdf-tools-install)
;;   (custom-set-variables
;;     '(pdf-tools-handle-upgrades t)))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook (lambda () (setq truncate-lines t)))

(use-package ox-clip
  :bind
  ("A-C-M-k" . ox-clip-formatted-copy))

(use-package org-contrib
  :after (org)
  :defer t)
  ;; :straight (:build t)
  ;; :init
  ;; (require 'ox-extra)
  ;; (ox-extras-activate '(latex-header-blocks ignore-headlines)))

(use-package ox-confluence
  :defer 3
  :ensure nil
  :after org)

(require 'ox-confluence)

;; оригинал https://pank.eu/blog/pretty-babel-src-blocks.html#coderef-symbol
(with-eval-after-load 'org
  (defvar-local rasmus/org-at-src-begin -1
    "Variable that holds whether last position was a ")

  (defvar rasmus/ob-header-symbol ?☰
    "Symbol used for babel headers")

  (defun rasmus/org-prettify-src--update ()
    (let ((case-fold-search t)
          (re "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*")
          found)
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward re nil t)
          (goto-char (match-end 0))
          (let ((args (org-trim
                       (buffer-substring-no-properties (point)
                                                       (line-end-position)))))
            (when (org-string-nw-p args)
              (let ((new-cell (cons args rasmus/ob-header-symbol)))
                (cl-pushnew new-cell prettify-symbols-alist :test #'equal)
                (cl-pushnew new-cell found :test #'equal)))))
        (setq prettify-symbols-alist
              (cl-set-difference prettify-symbols-alist
                                 (cl-set-difference
                                  (cl-remove-if-not
                                   (lambda (elm)
                                     (eq (cdr elm) rasmus/ob-header-symbol))
                                   prettify-symbols-alist)
                                  found :test #'equal)))
        ;; Clean up old font-lock-keywords.
        (font-lock-remove-keywords nil prettify-symbols--keywords)
        (setq prettify-symbols--keywords (prettify-symbols--make-keywords))
        (font-lock-add-keywords nil prettify-symbols--keywords)
        (while (re-search-forward re nil t)
          (font-lock-flush (line-beginning-position) (line-end-position))))))

  (defun rasmus/org-prettify-src ()
    "Hide src options via `prettify-symbols-mode'.

  `prettify-symbols-mode' is used because it has uncollpasing. It's
  may not be efficient."
    (let* ((case-fold-search t)
           (at-src-block (save-excursion
                           (beginning-of-line)
                           (looking-at "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*"))))
      ;; Test if we moved out of a block.
      (when (or (and rasmus/org-at-src-begin
                     (not at-src-block))
                ;; File was just opened.
                (eq rasmus/org-at-src-begin -1))
        (rasmus/org-prettify-src--update))
      ;; Remove composition if at line; doesn't work properly.
      ;; (when at-src-block
      ;;   (with-silent-modifications
      ;;     (remove-text-properties (match-end 0)
      ;;                             (1+ (line-end-position))
      ;;                             '(composition))))
      (setq rasmus/org-at-src-begin at-src-block)))

  (defun rasmus/org-prettify-symbols ()
    (mapc (apply-partially 'add-to-list 'prettify-symbols-alist)
          (cl-reduce 'append
                     (mapcar (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                             `(("#+begin_src" . ?✎) ;; ➤ 🖝 ➟ ➤ ✎
                               ("#+end_src"   . ?□) ;; ⏹
                               ("#+header:" . ,rasmus/ob-header-symbol)
                               ("#+begin_quote" . ?»)
                               ("#+end_quote" . ?«)))))
    (turn-on-prettify-symbols-mode)
    (add-hook 'post-command-hook 'rasmus/org-prettify-src t t))
  (add-hook 'org-mode-hook #'rasmus/org-prettify-symbols))
(setq prettify-symbols-unprettify-at-point 'right-edge)

(keymap-global-set "C-c k" 'kubed-prefix-map)
(keymap-global-set "s-k" #'kubed-transient)

(add-hook 'terraform-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2)
    (setq terraform-indent-level 2)))

(add-hook 'hcl-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2)
    (setq hcl-indent-level 2)))

;; terraform-org-mode.el
;; Режим для отображения .tf файлов в стиле org-mode
;; terraform-org-mode.el
;; (defun terraform-org-fold-all ()
;;   "Fold all blocks in terraform file"
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (let ((end (point-max)))
;;       (while (re-search-forward "{" end t)
;;         (backward-char)
;;         (when (not (eq (face-at-point) 'font-lock-string-face))
;;           (forward-char)
;;           (backward-list)
;;           (hide-entry))))))

;; (define-derived-mode terraform-org-mode hcl-mode "Terraform-Org"
;;   "Major mode for editing Terraform files with org-like visualization."

;;   (setq terraform-org-font-lock-keywords
;;         '(("\\(resource\\|data\\|variable\\|output\\|module\\)\\s-+\"\\([^\"]+\\)\"\\s-+\"\\([^\"]+\\)\""
;;            (1 'org-level-1)
;;            (2 'org-level-2)
;;            (3 'org-level-2))
;;           ("\\(locals\\|terraform\\)\\s-*{"
;;            1 'org-level-1)
;;           ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
;;            1 'org-level-3)
;;           ("^[ \t]+[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
;;            1 'org-level-4)
;;           ("^[ \t]+[ \t]+[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
;;            1 'org-level-5)
;;           ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*="
;;            1 'org-property-value)))

;;   (setq font-lock-defaults '(terraform-org-font-lock-keywords))
;;   (local-set-key (kbd "C-c C-f") 'terraform-org-fold-all))

;; (add-hook 'terraform-org-mode-hook
;;           (lambda ()
;;             (setq-local outline-regexp "\\(resource\\|data\\|variable\\|output\\|module\\|locals\\|terraform\\)\\s-+\\|^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*{")
;;             (outline-minor-mode 1)))

;; (add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-org-mode))

;; (provide 'terraform-org-mode)
;; ----------------- v3
(define-derived-mode terraform-org-mode hcl-mode "Terraform-Org"
  "Major mode for editing Terraform files with org-like visualization."

  (setq terraform-org-font-lock-keywords
        '(("\\(resource\\|data\\|variable\\|output\\|module\\)\\s-+\"\\([^\"]+\\)\"\\s-+\"\\([^\"]+\\)\""
           (1 'org-level-1)
           (2 'org-level-2)
           (3 'org-level-2))
          ("\\(locals\\|terraform\\)\\s-*{"
           1 'org-level-1)
          ;; Блоки первого уровня вложенности
          ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
           1 'org-level-3)
          ;; Блоки второго уровня вложенности
          ("^[ \t]+[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
           1 'org-level-4)
          ;; Блоки третьего уровня вложенности
          ("^[ \t]+[ \t]+[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
           1 'org-level-5)
          ;; Свойства
          ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*="
           1 'org-property-value)))

  (setq font-lock-defaults '(terraform-org-font-lock-keywords)))

(add-hook 'terraform-org-mode-hook
          (lambda ()
            (setq-local outline-regexp "\\(resource\\|data\\|variable\\|output\\|module\\|locals\\|terraform\\)\\s-+\\|^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*{")
            (outline-minor-mode 1)))

(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-org-mode))

(provide 'terraform-org-mode)
;; ---------------- v2
;; (define-derived-mode terraform-org-mode hcl-mode "Terraform-Org"
;;   "Major mode for editing Terraform files with org-like visualization."

;;   (setq terraform-org-font-lock-keywords
;;         '(("\\(resource\\|data\\|variable\\|output\\|module\\)\\s-+\"\\([^\"]+\\)\"\\s-+\"\\([^\"]+\\)\""
;;            (1 'org-level-1)
;;            (2 'org-level-2)
;;            (3 'org-level-2))
;;           ("\\(locals\\|terraform\\)\\s-*{"
;;            1 'org-level-1)
;;           ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*{"
;;            1 'org-level-3)
;;           ("^[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*="
;;            1 'org-property-value)))

;;   (setq font-lock-defaults '(terraform-org-font-lock-keywords)))

;; (add-hook 'terraform-org-mode-hook
;;           (lambda ()
;;             (setq-local outline-regexp "\\(resource\\|data\\|variable\\|output\\|module\\|locals\\|terraform\\)\\s-+")
;;             (outline-minor-mode 1)))

;; (add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-org-mode))

;; (provide 'terraform-org-mode)
;; ------------------------- v1
;; (define-derived-mode terraform-org-mode hcl-mode "Terraform-Org"
;;   "Major mode for editing Terraform files with org-like visualization."

;;   (setq terraform-org-font-lock-keywords
;;         '(("\\(resource\\|data\\|variable\\|output\\|module\\)\\s-+\"\\([^\"]+\\)\"\\s-+\"\\([^\"]+\\)\""
;;            (1 'org-level-1)
;;            (2 'org-level-2)
;;            (3 'org-level-2))
;;           ("\\(locals\\|terraform\\)\\s-*{"
;;            1 'org-level-1)
;;           ("^\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*{"
;;            1 'org-level-3)
;;           ("\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*="
;;            1 'org-property-value)))

;;   (setq font-lock-defaults '(terraform-org-font-lock-keywords)))

;; (add-hook 'terraform-org-mode-hook
;;           (lambda ()
;;             (outline-minor-mode 1)))

;; (add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-org-mode))

;; (provide 'terraform-org-mode)
;; --------------------------- v0
;; (define-derived-mode terraform-org-mode hcl-mode "Terraform-Org"
;;   "Major mode for editing Terraform files with org-like visualization."

;;   ;; Определяем основные группы для подсветки
;;   (setq terraform-org-font-lock-keywords
;;         '(("\\(resource\\|data\\|variable\\|output\\|module\\)\\s-+\"\\([^\"]+\\)\"\\s-+\"\\([^\"]+\\)\""
;;            (1 'org-level-1)  ; Тип блока как заголовок первого уровня
;;            (2 'org-level-2)  ; Имя ресурса как подзаголовок
;;            (3 'org-level-2)) ; Название как подзаголовок
;;           ("\\(locals\\|terraform\\)\\s-*{"
;;            1 'org-level-1)
;;           ("\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*="
;;            1 'org-property-value)))

;;   ;; Применяем правила подсветки
;;   (setq font-lock-defaults '(terraform-org-font-lock-keywords)))

;; ;; Добавляем поддержку сворачивания блоков как в org-mode
;; (add-hook 'terraform-org-mode-hook
;;           (lambda ()
;;             (setq-local outline-regexp "\\(resource\\|data\\|variable\\|output\\|module\\|locals\\|terraform\\)\\s-+")
;;             (outline-minor-mode 1)))

;; ;; Ассоциируем .tf файлы с новым режимом
;; (add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-org-mode))

;; (provide 'terraform-org-mode)

;; (use-package editorconfig
;;   :ensure t
;;   :config
;;   (editorconfig-mode 1))

(use-package company-terraform
  :after (company terraform-mode)
  :config (add-to-list 'company-backends 'company-terraform))

;; https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
;; https://www.masteringemacs.org/article/combobulate-structured-movement-editing-treesitter
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package treesit
  :mode (("\\.tsx\\'" . tsx-ts-mode))
  :preface
  (defun mp-setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             ;; Note the version numbers. These are the versions that
             ;; are known to work with Combobulate *and* Emacs.
             '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (go . ("https://github.com/tree-sitter/tree-sitter-go" "v0.23.4"))
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.23.2"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1" "src"))
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.24.8"))
               (markdown . ("https://github.com/ikatyang/tree-sitter-markdown" "v0.7.1"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.23.6"))
               (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "v0.21.2"))
               (toml . ("https://github.com/tree-sitter/tree-sitter-toml" "v0.5.1"))
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))))
      (add-to-list 'treesit-language-source-alist grammar)
      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional. Combobulate works in both xxxx-ts-modes and
  ;; non-ts-modes.

  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  (dolist (mapping
           '((python-mode . python-ts-mode)
             (css-mode . css-ts-mode)
             (typescript-mode . typescript-ts-mode)
             (js2-mode . js-ts-mode)
             (bash-mode . bash-ts-mode)
             (conf-toml-mode . toml-ts-mode)
             (go-mode . go-ts-mode)
             (css-mode . css-ts-mode)
             (json-mode . json-ts-mode)
             (js-json-mode . json-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))
  :config
  (mp-setup-install-grammars)
  ;; Do not forget to customize Combobulate to your liking:
  ;;
  ;;  M-x customize-group RET combobulate RET
  ;;
  (use-package combobulate
    :custom
    ;; You can customize Combobulate's key prefix here.
    ;; Note that you may have to restart Emacs for this to take effect!
    (combobulate-key-prefix "C-c o")
    :hook ((prog-mode . combobulate-mode))
    ;; Amend this to the directory where you keep Combobulate's source
    ;; code.
    :load-path ("~/.emacs.d/combobulate")))

;; версия с сайта https://zzamboni.org/post/my-emacs-configuration-with-commentary/
;; (with-eval-after-load 'org
;;   (defvar-local rasmus/org-at-src-begin -1
;;     "Variable that holds whether last position was a ")

;;   (defvar rasmus/ob-header-symbol ?☰
;;     "Symbol used for babel headers")

;;   (defun rasmus/org-prettify-src--update ()
;;     (let ((case-fold-search t)
;;           (re "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*")
;;           found)
;;       (save-excursion
;;         (goto-char (point-min))
;;         (while (re-search-forward re nil t)
;;           (goto-char (match-end 0))
;;           (let ((args (org-trim
;;                        (buffer-substring-no-properties (point)
;;                                                        (line-end-position)))))
;;             (when (org-string-nw-p args)
;;               (let ((new-cell (cons args rasmus/ob-header-symbol)))
;;                 (cl-pushnew new-cell prettify-symbols-alist :test #'equal)
;;                 (cl-pushnew new-cell found :test #'equal)))))
;;         (setq prettify-symbols-alist
;;               (cl-set-difference prettify-symbols-alist
;;                                  (cl-set-difference
;;                                   (cl-remove-if-not
;;                                    (lambda (elm)
;;                                      (eq (cdr elm) rasmus/ob-header-symbol))
;;                                    prettify-symbols-alist)
;;                                   found :test #'equal)))
;;         ;; Clean up old font-lock-keywords.
;;         (font-lock-remove-keywords nil prettify-symbols--keywords)
;;         (setq prettify-symbols--keywords (prettify-symbols--make-keywords))
;;         (font-lock-add-keywords nil prettify-symbols--keywords)
;;         (while (re-search-forward re nil t)
;;           (font-lock-flush (line-beginning-position) (line-end-position))))))

;;   (defun rasmus/org-prettify-src ()
;;     "Hide src options via `prettify-symbols-mode'.

;;         `prettify-symbols-mode' is used because it has uncollpasing. It's
;;         may not be efficient."
;;     (let* ((case-fold-search t)
;;            (at-src-block (save-excursion
;;                            (beginning-of-line)
;;                            (looking-at "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*"))))
;;       ;; Test if we moved out of a block.
;;       (when (or (and rasmus/org-at-src-begin
;;                      (not at-src-block))
;;                 ;; File was just opened.
;;                 (eq rasmus/org-at-src-begin -1))
;;         (rasmus/org-prettify-src--update))
;;       ;; Remove composition if at line; doesn't work properly.
;;       ;; (when at-src-block
;;       ;;   (with-silent-modifications
;;       ;;     (remove-text-properties (match-end 0)
;;       ;;                             (1+ (line-end-position))
;;       ;;                             '(composition))))
;;       (setq rasmus/org-at-src-begin at-src-block)))

;;   ;; This function helps to produce a single glyph out of a
;;   ;; string. The glyph can then be used in prettify-symbols-alist.
;;   ;; This function was provided by Ihor in the org-mode mailing list.
;;   (defun yant/str-to-glyph (str)
;;     "Transform string into glyph, displayed correctly."
;;     (let ((composition nil))
;;       (dolist (char (string-to-list str)
;;                     (nreverse (cdr composition)))
;;         (push char composition)
;;         (push '(Br . Bl) composition))))

;;   (defun rasmus/org-prettify-symbols ()
;;     (mapc (apply-partially 'add-to-list 'prettify-symbols-alist)
;;           (cl-reduce 'append
;;                      (mapcar (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
;;                              `(("#+begin_src" . ?⎡) ;; ⎡ ➤ 🖝 ➟ ➤ ✎
;;                                ;; multi-character strings can be used with something like this:
;;                                ;; ("#+begin_src" . ,(yant/str-to-glyph "```"))
;;                                ("#+end_src"   . ?⎣) ;; ⎣ ✐
;;                                ("#+header:" . ,rasmus/ob-header-symbol)
;;                                ("#+begin_quote" . ?«)
;;                                ("#+end_quote" . ?»)))))
;;     (turn-on-prettify-symbols-mode)
;;     (add-hook 'post-command-hook 'rasmus/org-prettify-src t t))
;;   (add-hook 'org-mode-hook #'rasmus/org-prettify-symbols))

(defun my-org-edit-src-code-minibuffer ()
  (interactive)
  (setq org-src-window-setup 'reorganize-frame)
  (setq split-window-preferred-function
        (lambda (window)
          (let ((new-window (split-window-below
                            (round (* 0.1 (window-height window))))))
            new-window)))
  (org-edit-src-code))

(defun my-org-edit-src-code-new-frame ()
  (interactive)
  (setq org-src-window-setup 'other-frame)
  (org-edit-src-code))

(define-key org-mode-map (kbd "C-c '") 'my-org-edit-src-code-minibuffer)
(define-key org-mode-map (kbd "C-c \"") 'my-org-edit-src-code-new-frame)

(load (expand-file-name "~/.quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

(defun my/org-babel-comment-formatter (lang src-file source-name comment)
  ;; "Создает структурированный комментарий для tangle/detangle операций.
  ;;  LANG - язык исходного кода
  ;;  SRC-FILE - путь к org файлу
  ;;  SOURCE-NAME - имя блока кода
  ;;  COMMENT - значение из :tangle-comment"
  (let* ((abs-path (expand-file-name src-file))
         (block-ref (or source-name "unnamed"))
         (description (or comment "no description")))
    (format "[[file:%s::%s][%s]]"
            abs-path
            block-ref
            description)))

(defun my/org-babel-setup ()
  ;; "Настраивает параметры для tangle/detangle"
  (setq org-babel-tangle-comment-format-function #'my/org-babel-comment-formatter)
  (setq org-babel-tangle-comment-format-end "")
  (setq org-babel-detangle-snippets-dir nil))

;; Применяем настройки при запуске
(add-hook 'org-mode-hook #'my/org-babel-setup)

;; Prometheus for org babel
(require 'ob)
(require 'json)

(defvar org-babel-default-header-args:prometheus
  '((:results . "value table") (:exports . "results"))
  "Default arguments for evaluating a prometheus source block.")

(defvar prometheus-default-url "http://localhost:9090"
  "Default Prometheus server URL.")

;; (setq prometheus-default-url "http://prometheus.wldev.app")

(defun prometheus-query-region (start end)
  "Send selected Prometheus query to server and show results as table."
  (interactive "r")
  (let* ((query (buffer-substring-no-properties start end))
         (url (or (and (boundp 'prometheus-default-url) prometheus-default-url)
                  "http://localhost:9090"))
         (api-url (format "%s/api/v1/query" url))
         (cmd (format "curl -sG %s --data-urlencode 'query=%s'" api-url query))
         (json-output (shell-command-to-string cmd))
         (parsed (ignore-errors (json-parse-string json-output :object-type 'alist))))
    (if (not parsed)
        (message "Failed to parse JSON response from Prometheus")
      (let* ((results (alist-get 'result (alist-get 'data parsed)))
             (keys (delete-dups
                    (apply #'append
                           (mapcar (lambda (item)
                                     (mapcar #'car
                                             (seq-remove (lambda (kv)
                                                           (string= (car kv) "__name__"))
                                                         (alist-get 'metric item))))
                                   results))))
             (sorted-keys (sort keys #'string<))
             (rows (mapcar
                    (lambda (item)
                      (let* ((metric (alist-get 'metric item))
                             (value-pair (alist-get 'value item))
                             (ts-raw (aref value-pair 0))
                             (val (aref value-pair 1))
                             (ts (format-time-string
                                  "%Y-%m-%d %H:%M:%S"
                                  (seconds-to-time
                                   (if (numberp ts-raw) ts-raw (string-to-number ts-raw)))))
                             (row (mapcar (lambda (k)
                                            (or (alist-get k metric nil nil #'string=) ""))
                                          sorted-keys)))
                        (append row (list val ts))))
                    results)))
        ;; выводим в буфер и фокусируемся
        (with-output-to-temp-buffer "*Prometheus Result*"
          (princ (format "| %s | value | timestamp |\n"
                         (mapconcat 'identity sorted-keys " | ")))
          (princ (make-string (+ (* (length sorted-keys) 15) 30) ?-))
          (princ "\n")
          (dolist (row rows)
            (princ (format "| %s |\n"
                           (mapconcat 'identity row " | "))))
          (with-current-buffer "*Prometheus Result*"
            (goto-char (point-min)))
          (select-window (display-buffer "*Prometheus Result*")))))))

(global-set-key (kbd "C-c p") 'prometheus-query-region)

(defun org-babel-execute:prometheus (body params)
  "Execute a Prometheus query using curl, parse JSON, return org table with label columns and timestamp."
  (let* (
         ;; шаблонные переменные {{var}}
         (vars (mapcar (lambda (pair)
                         (cons (symbol-name (car pair)) (cdr pair)))
                       (org-babel--get-vars params)))
         (query-template body)
         (query (seq-reduce
                 (lambda (q var)
                   (replace-regexp-in-string
                    (format "{{%s}}" (car var))
                    (format "%s" (cdr var))
                    q))
                 vars
                 query-template))

         ;; параметры
         (url (or (cdr (assoc :prometheus_url params))
                  (org-babel-prometheus-get-url)
                  prometheus-default-url))
         (api-url (format "%s/api/v1/query" url))
         (cmd (format "curl -sG %s --data-urlencode 'query=%s'" api-url query))
         (json-output (shell-command-to-string cmd))
         (parsed (ignore-errors (json-parse-string json-output :object-type 'alist))))

    (if (and parsed (equal (alist-get 'status parsed) "success"))
        (let* (
               ;; из Prometheus
               (raw-results (alist-get 'result (alist-get 'data parsed)))

               ;; применим :filter как постфильтр (например, job=nginx,namespace=dev)
               (results
                (let ((filter (cdr (assoc :filter params))))
                  (if (and filter (not (string-empty-p filter)))
                      (let* ((pairs (mapcar (lambda (s)
                                              (let ((kv (split-string s "=")))
                                                (cons (car kv) (cadr kv))))
                                            (split-string filter ","))))
                        (seq-filter
                         (lambda (item)
                           (let ((metric (alist-get 'metric item)))
                             (seq-every-p (lambda (kv)
                                            (string= (alist-get (car kv) metric nil nil #'string=)
                                                     (cdr kv)))
                                          pairs)))
                         raw-results))
                    raw-results)))

               ;; собираем все метки
               (all-keys (delete-dups
                          (apply #'append
                                 (mapcar (lambda (item)
                                           (mapcar #'car
                                                   (seq-remove (lambda (kv)
                                                                 (string= (car kv) "__name__"))
                                                               (alist-get 'metric item))))
                                         results))))
               (sorted-keys (sort all-keys #'string<))

               ;; строим таблицу
               (table
                (mapcar
                 (lambda (item)
                   (let* ((metric (alist-get 'metric item))
                          (value-pair (alist-get 'value item))
                          (ts-raw (aref value-pair 0))
                          (val (aref value-pair 1))
                          (ts (format-time-string
                               "%Y-%m-%d %H:%M:%S"
                               (seconds-to-time
                                (if (numberp ts-raw) ts-raw (string-to-number ts-raw)))))
                          (row (mapcar (lambda (key)
                                         (or (alist-get key metric nil nil #'string=) ""))
                                       sorted-keys)))
                     (append row (list val ts))))
                 results)))
          ;; результат: заголовки + строки
          (append (list (append sorted-keys (list "value" "timestamp"))) table))

      ;; в случае ошибки
      (format "Prometheus query failed or returned error:\n%s" json-output))))

(defun org-babel-prometheus-get-url ()
  "Fetch prometheus_url from org document PROPERTY drawer."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+PROPERTY: +prometheus_url +\\(.*\\)$" nil t)
      (match-string 1))))

;; Register language
(add-to-list 'org-babel-load-languages '(prometheus . t))

(setq default-truncate-lines t)
(global-visual-line-mode 1)

;; 📦 Убедись, что GPG установлен в системе
;;     - macOS: brew install gnupg
;;     - Ubuntu: sudo apt install gnupg
;;     - Windows: установить Gpg4win

(defun debug-gpg-setup ()
  "Диагностика GPG настроек"
  (interactive)
  (message "=== GPG Debug Info ===")
  (message "epg-gpg-program: %s" epg-gpg-program)
  (message "epa-pinentry-mode: %s" epa-pinentry-mode)
  (message "epg-passphrase-callback: %s" epg-passphrase-callback)
  (message "my-gpg-passphrase-cache: %s" (if my-gpg-passphrase-cache "SET" "NIL"))
  (message "GPG Agent Status:")
  (message "%s" (shell-command-to-string "gpg-agent --version 2>/dev/null || echo 'GPG Agent not found'"))
  (message "GPG Keys:")
  (message "%s" (shell-command-to-string "gpg --list-secret-keys --keyid-format=long 2>/dev/null || echo 'No keys found'")))

;; 📂 Загружаем org и org-crypt
;; (require 'org)
(require 'org-crypt)

;; 🔐 Включаем автоматическое шифрование заголовков с тегом :crypt:
(org-crypt-use-before-save-magic)

;; 🔑 Используем GPG-ключ по умолчанию (если у тебя один)
(setq org-crypt-key "opponyol@gmail.com")

;; 🧬 Тег :crypt: не наследуется дочерними заголовками по умолчанию
(setq org-tags-exclude-from-inheritance '("crypt"))

;; 💾 Разрешаем автосохранение зашифрованных блоков (по желанию)
(setq org-crypt-disable-auto-save nil)

;; 📎 Расширения GPG
;; Emacs автоматически обрабатывает .gpg файлы — дополнительных настроек не требуется,
;; но можно явно указать, что использовать GnuPG:
(setq epg-gpg-program "gpg")

;; 🪄 Упрощаем ввод пароля (если установлен gpg-agent / pinentry)
(setq epa-pinentry-mode 'loopback)
(setq epa-file-select-keys nil)

(defvar my-gpg-passphrase-cache nil
  "Временное хранилище GPG-пароля для текущего сеанса Emacs.")

(defun my-epg-passphrase-callback (_context key-id _ignore)
  "Запрашивает пароль один раз за сеанс Emacs."
  (or my-gpg-passphrase-cache
      (setq my-gpg-passphrase-cache
            (read-passwd (format "GPG passphrase for %s: " key-id)))))

(defun my-clear-gpg-passphrase ()
  "Очищает кэш GPG-пароля."
  (interactive)
  (setq my-gpg-passphrase-cache nil)
  (message "GPG passphrase cache cleared"))

(setq epg-passphrase-callback #'my-epg-passphrase-callback)

;; Пример бинда для ручного сброса
(global-set-key (kbd "C-c g c") #'my-clear-gpg-passphrase)

;; Опционально: отключить предупреждение при открытии зашифрованных блоков
;; (setq org-crypt-remove-after-decrypt t)

;; 🔁 Обновим org-mode (если используешь use-package)
;; (use-package org :ensure t)

(define-key org-mode-map (kbd "C-c d") 'org-decrypt-entry)
(message "✅ org-crypt и GPG настроены!")

;; (add-hook 'shell-mode-hook
;;           (lambda ()
;;             (setq comint-input-ring-file-name nil)
;;             (setq comint-input-ring-size 1)
;;             (setq comint-input-ring (make-ring 1))
;;             (setq comint-input-ignoredups t)))
(add-hook 'shell-mode-hook
          (lambda ()
            (setq comint-input-ring-file-name nil)
            (setq comint-input-ignoredups t)))

;; for eat terminal backend:
(quelpa '(eat :fetcher git
              :url "https://codeberg.org/akib/emacs-eat"
              :files ("*.el" ("term" "term/*.el") "*.texi"
                      "*.ti" ("terminfo/e" "terminfo/e/*")
                      ("terminfo/65" "terminfo/65/*")
                      ("integration" "integration/*")
                      (:exclude ".dir-locals.el" "*-tests.el"))))

(use-package eat :ensure t)

;; for vterm terminal backend:
(use-package vterm :ensure t)

;; (require 'package-vc)
;; install claude-code.el
;; (use-package claude-code :ensure t
;;   :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
;;   :config (claude-code-mode)
;;   :bind-keymap ("C-c a" . claude-code-command-map))

(modify-frame-parameters nil '((name . "main")))

;; (defun my/assign-frame-name-delayed (frame)
;;   "Prompt for frame name shortly after FRAME is created."
;;   (run-at-time
;;    "0.1 sec" nil
;;    (lambda ()
;;      (when (frame-live-p frame)
;;        (with-selected-frame frame
;;          (let ((name (read-string "Name for new frame (leave blank for auto): ")))
;;            (set-frame-name
;;             (if (string-empty-p name)
;;                 (my/generate-auto-frame-name frame)
;;               name)))))))

;; (defun my/generate-auto-frame-name (frame)
;;   "Generate a fallback name for a FRAME."
;;   (format "Frame-%s"
;;           (or (frame-parameter frame 'window-id)
;;               (frame-parameter frame 'outer-window-id)
;;               (format-time-string "%H%M%S"))))

;; (add-hook 'after-make-frame-functions #'my/assign-frame-name-delayed)

(defun my/consult-frame-switch ()
  (interactive)
  (let ((frame (consult--read
                (mapcar (lambda (f)
                          (propertize (frame-parameter f 'name) 'frame f))
                        (frame-list))
                :prompt "Switch to frame: ")))
    (select-frame-set-input-focus
     (get-text-property 0 'frame frame))))

;; (defun my/next-frame-with-message ()
;;   "Переключиться на следующий фрейм с сообщением."
;;   (interactive)
;;   (other-frame 1)
;;   (message "Фрейм: %s" (frame-parameter nil 'name)))

;; (defun my/previous-frame-with-message ()
;;   "Переключиться на предыдущий фрейм с сообщением."
;;   (interactive)
;;   (other-frame -1)
;;   (message "Фрейм: %s" (frame-parameter nil 'name)))

;; История посещенных фреймов
(defvar my/frame-history '()
  "Список фреймов в порядке последнего посещения.")

(defvar my/frame-history-index 0
  "Текущая позиция в истории фреймов.")

(defun my/update-frame-history (frame)
  "Обновить историю фреймов, добавив FRAME в начало."
  (setq my/frame-history
        (cons frame (remove frame my/frame-history)))
  (setq my/frame-history-index 0))

(defun my/track-frame-focus (frame)
  "Отслеживать смену фокуса фрейма."
  (unless (eq frame (car my/frame-history))
    (my/update-frame-history frame)))

;; Подключить отслеживание
(add-hook 'focus-in-hook
          (lambda () (my/track-frame-focus (selected-frame))))

(defun my/next-frame-with-message ()
  "Переключиться на следующий фрейм в истории с сообщением."
  (interactive)
  (when (> (length my/frame-history) 1)
    (setq my/frame-history-index
          (if (>= my/frame-history-index (1- (length my/frame-history)))
              0
            (1+ my/frame-history-index)))
    (let ((target-frame (nth my/frame-history-index my/frame-history)))
      (when (frame-live-p target-frame)
        (select-frame-set-input-focus target-frame)
        (message "Фрейм: %s (вперед %d/%d)"
                 (frame-parameter target-frame 'name)
                 (1+ my/frame-history-index)
                 (length my/frame-history))))))

(defun my/previous-frame-with-message ()
  "Переключиться на предыдущий фрейм в истории с сообщением."
  (interactive)
  (when (> (length my/frame-history) 1)
    (setq my/frame-history-index
          (if (<= my/frame-history-index 0)
              (1- (length my/frame-history))
            (1- my/frame-history-index)))
    (let ((target-frame (nth my/frame-history-index my/frame-history)))
      (when (frame-live-p target-frame)
        (select-frame-set-input-focus target-frame)
        (message "Фрейм: %s (назад %d/%d)"
                 (frame-parameter target-frame 'name)
                 (1+ my/frame-history-index)
                 (length my/frame-history))))))

;; Функция для показа истории
(defun my/show-frame-history ()
  "Показать текущую историю фреймов."
  (interactive)
  (message "История фреймов: %s"
           (mapconcat (lambda (f)
                       (frame-parameter f 'name))
                      my/frame-history " -> ")))

;; Очистка истории от закрытых фреймов
(defun my/cleanup-frame-history ()
  "Удалить из истории закрытые фреймы."
  (setq my/frame-history
        (seq-filter 'frame-live-p my/frame-history))
  (when (>= my/frame-history-index (length my/frame-history))
    (setq my/frame-history-index 0)))

;; Добавить хук для очистки
(add-hook 'delete-frame-functions
          (lambda (frame)
            (my/cleanup-frame-history)))

(my/update-frame-history (selected-frame))

(global-set-key (kbd "s-<up>") 'my/next-frame-with-message)
(global-set-key (kbd "s-<down>") 'my/previous-frame-with-message)
(global-set-key (kbd "s-/") 'my/show-frame-history)

(defun display-buffer-path ()
  "Show the full path of the current buffer’s file."
  (interactive)
  (let ((path (buffer-file-name)))          ; ← берём абсолютный путь
    (if path
        (message "%s" path)                  ; печатаем в minibuffer
      (message "Этот буфер не связан с файлом"))))

(global-set-key (kbd "s-\\") #'display-buffer-path)

;; (global-set-key (kbd "M-o") #'my/consult-frame-switch)
;; (global-set-key (kbd "M-p") #'set-frame-name)
(global-set-key (kbd "s-o") #'my/consult-frame-switch)
(global-set-key (kbd "s-p") #'set-frame-name)

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings))

(setq grep-program "rg"
      grep-command "rg --color=never --no-heading --line-number --smart-case "
      grep-template "rg --color=never --no-heading --line-number --smart-case <R> <F>"
      grep-find-template "rg --color=never --no-heading --line-number --smart-case <R> <D>")

(setq rg-ignore-case 'smart)
(setq rg-default-alias-fallback "everything")

(global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

(setq-default mode-line-format
              (list
               '(:eval (format "[%s] " (frame-parameter nil 'name)))
               mode-line-format))

;; (use-package geist-font :ensure t
;;   :vc (:url "https://github.com/shaneikennedy/geist-font.el" :rev :newest))

(use-package bm
  :ensure t
  :bind (("s-1" . bm-toggle)
         ("s-2" . bm-next)
         ("s-3" . bm-previous)
         ("s-4" . bm-remove-all-current-buffer))
  :init
  ;; Настройки ДО загрузки пакета
  (setq bm-restore-repository-on-load t)
  (setq bm-buffer-persistence t)
  (setq bm-highlight-style 'bm-highlight-line-and-fringe)
  (setq bm-cycle-all-buffers t)

  :config
  ;; Hooks ПОСЛЕ загрузки пакета (когда функции уже определены)
  (add-hook 'after-init-hook 'bm-repository-load)
  (add-hook 'find-file-hook 'bm-buffer-restore)
  (add-hook 'kill-buffer-hook 'bm-buffer-save)
  (add-hook 'kill-emacs-hook #'(lambda nil
                                  (bm-buffer-save-all)
                                  (bm-repository-save)))

  ;; Дополнительные полезные хуки
  (add-hook 'after-save-hook #'bm-buffer-save)
  (add-hook 'vc-before-checkin-hook #'bm-buffer-save))

;; Опционально: показать все закладки в списке
(global-set-key (kbd "s-<f2>") 'bm-show-all)

(global-set-key (kbd "s-r") 'copy-to-register)
(global-set-key (kbd "s-i") 'insert-register)

(defun my/memory-report ()
  "Показать детальную информацию о памяти"
  (interactive)
  (message "Memory usage: GC %d times, %s"
           gcs-done
           (if (fboundp 'memory-usage)
               (format "Total: %s" (memory-usage))
             "Use M-x memory-usage for details")))

(global-set-key (kbd "C-c M-m") 'my/memory-report)

;; -----------------------------------------------------------------
;; GARBAGE COLLECTION OPTIMIZATION
;; -----------------------------------------------------------------

;; Увеличить threshold для GC (более редкие, но эффективные сборки)
(setq gc-cons-threshold (* 100 1024 1024))    ; 100MB вместо 800KB по умолчанию
(setq gc-cons-percentage 0.1)                 ; 10% вместо 0.1% по умолчанию

;; Показывать когда происходит GC (для диагностики)
(setq garbage-collection-messages t)

;; Принудительная GC при idle (когда Emacs не используется)
(run-with-idle-timer 600 t 'garbage-collect)  ; каждые 5 минут idle

(defun my/check-large-buffers ()
  "Показать буферы размером больше 50MB"
  (interactive)
  (let ((large-buffers '()))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (> (buffer-size) (* 1 1024 1024))  ; 50MB
          (push (format "%s: %s"
                        (buffer-name)
                        (file-size-human-readable (buffer-size)))
                large-buffers))))
    (if large-buffers
        (message "Large buffers: %s" (string-join large-buffers ", "))
      (message "No large buffers found"))))

;; Привязать к клавише для быстрой диагностики
(global-set-key (kbd "C-c M-b") 'my/check-large-buffers)

(add-hook 'shell-mode-hook
  (lambda ()
    ;; Ограничения для shell
    (setq-local comint-buffer-maximum-size 5000)
    (setq-local comint-scroll-to-bottom-on-input t)
    (setq-local comint-scroll-to-bottom-on-output t)
    ;; Не сохранять историю в больших буферах
    (setq-local comint-input-ring-size 100)))

(add-hook 'eshell-mode-hook
  (lambda ()
    (setq-local eshell-buffer-maximum-lines 3000)
    ;; Автоматически очищать старые строки
    (setq-local eshell-scroll-to-bottom-on-input t)
    ;; Ограничить историю команд
    (setq-local eshell-history-size 500)))

;; eat terminal
(with-eval-after-load 'eat
  (setq eat-buffer-maximum-size 8000))

;; vterm
(with-eval-after-load 'vterm
  (setq vterm-buffer-maximum-size 10000))

;; Очищать shell буферы каждые 30 минут
(defun my/cleanup-shell-buffers ()
  "Truncate all shell buffers to reasonable size"
  (interactive)
  (let ((cleaned 0))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (or (derived-mode-p 'comint-mode)
                  (derived-mode-p 'eshell-mode)
                  (derived-mode-p 'eat-mode)
                  (derived-mode-p 'vterm-mode))
          (when (> (buffer-size) (* 1024 1024)) ; > 1MB
            (cond
             ((derived-mode-p 'comint-mode)
              (comint-truncate-buffer))
             ((derived-mode-p 'eshell-mode)
              (eshell-truncate-buffer)))
            (setq cleaned (1+ cleaned))))))
    (when (> cleaned 0)
      (message "Cleaned %d shell buffers" cleaned))))

;; Запускать каждые 30 минут
(run-with-idle-timer 1800 t 'my/cleanup-shell-buffers)

(defun my/show-large-shell-buffers ()
  "Show shell buffers larger than 1MB"
  (interactive)
  (let ((large-buffers '()))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (or (derived-mode-p 'comint-mode)
                       (derived-mode-p 'eshell-mode)
                       (derived-mode-p 'eat-mode))
                   (> (buffer-size) (* 1024 1024)))
          (push (format "%s: %s lines, %s"
                        (buffer-name)
                        (count-lines (point-min) (point-max))
                        (file-size-human-readable (buffer-size)))
                large-buffers))))
    (if large-buffers
        (message "Large shell buffers:\n%s" (string-join large-buffers "\n"))
      (message "No large shell buffers found"))))

;; Bind для быстрой проверки
(global-set-key (kbd "C-c M-s") 'my/show-large-shell-buffers)

(geist-font--install)
(ignore-errors (set-frame-font "Geist Mono-15"))
(set-face-attribute 'default nil :font "Geist Mono-15")

;; ======================================================
;; Buffer Cleanup Configuration for Emacs
;; ======================================================

;; 1. Автоматическая уборка старых буферов через midnight.el
(require 'midnight)

;; Запускать уборку каждые 2 часа
(setq midnight-period 7200)

;; Первый запуск в 2:00 утра
(midnight-delay-set 'midnight-delay "10:00am")

;; Настройки возраста буферов
(setq clean-buffer-list-delay-general 2    ; обычные буферы - 3 дня
      clean-buffer-list-delay-special 1)   ; специальные буферы - 1 день

;; Буферы которые НИКОГДА не удалять (дополнительно к defaults)
(setq clean-buffer-list-kill-never-buffer-names
      (append clean-buffer-list-kill-never-buffer-names
              '("*scratch*" "*Messages*" "*Warnings*" "*dashboard*" "wldev" "cincin")))

;; ======================================================
;; 2. Кастомная функция для удаления буферов с мертвыми файлами
;; ======================================================

(defun kill-non-file-buffers-with-dead-files ()
  "Kill buffers visiting files that no longer exist on disk."
  (interactive)
  (let ((killed-count 0))
    (dolist (buffer (buffer-list))
      (let ((filename (buffer-file-name buffer)))
        (when (and filename                    ; буфер связан с файлом
                   (not (file-exists-p filename))) ; файл не существует
          (kill-buffer buffer)
          (setq killed-count (1+ killed-count)))))
    (message "Killed %d buffers with non-existent files" killed-count)))

;; ======================================================
;; 3. Горячие клавиши
;; ======================================================

;; Ручная очистка мертвых буферов
(global-set-key (kbd "C-c k d") 'kill-non-file-buffers-with-dead-files)

;; Ручной вызов general cleanup
(global-set-key (kbd "C-c k c") 'clean-buffer-list)

;; Интерактивная очистка
(global-set-key (kbd "C-c k s") 'kill-some-buffers)

;; ======================================================
;; 4. Включение автоматической уборки
;; ======================================================

;; Запустить midnight mode
(midnight-mode 1)

;; ======================================================
;; AI Code Interface - ПРАВИЛЬНАЯ настройка
;; ======================================================
;; install claude-code.el
;; (use-package monet
;;   :vc (:url "https://github.com/stevemolitor/monet" :rev :newest))

;; (run-with-idle-timer 5 nil #'package-vc-upgrade-all)

;; (use-package ghostel
;;   :vc (:url "https://github.com/dakra/ghostel"
;;        :lisp-dir "lisp"
;;        :rev :newest))

(use-package claude-code :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config
  ;; optional IDE integration with Monet
  ;; (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
  ;; (monet-mode 1)

  (claude-code-mode)
  :bind-keymap ("C-c b" . claude-code-command-map)

  ;; Optionally define a repeat map so that "M" will cycle thru Claude auto-accept/plan/confirm modes after invoking claude-code-cycle-mode / C-c M.
  :bind
  (:repeat-map my-claude-code-map ("M" . claude-code-cycle-mode)))

;; reduce flickering
(add-hook 'claude-code-start-hook
          (lambda ()
            (setq-local eat-minimum-latency 0.033
                        eat-maximum-latency 0.1)))

;; (setq claude-code-terminal-backend 'ghostel)
(setq claude-code-terminal-backend 'eat)

;; (use-package web-server
;;   :ensure t)

;; (use-package claude-code-ide
;;   :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
;;   ;; :bind ("s-a" . claude-code-ide-menu) ; Set your favorite keybinding
;;   :bind ("C-c b" . claude-code-ide-menu) ; Set your favorite keybinding
;;   :config
;;   (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

;; (setq claude-code-ide-terminal-backend 'eat)

;; ;; ======================================================
;; ;; AI Code Interface - ИНТЕРФЕЙС (потом!)
;; ;; ======================================================

;; (use-package ai-code-interface
;;   :load-path "manual-packages/ai-code-interface"
;;   :bind ("C-c b" . ai-code-menu)
;;   :config
;;   ;; Теперь можно установить бэкенд
;;   (ai-code-set-backend 'claude-code-ide)

;;   ;; Настройка для magit
;;   (with-eval-after-load 'magit
;;     (ai-code-magit-setup-transients)))


;; (setq debug-on-error t)
;; (setq org-babel-tangle-verbose t)
;; (require 'ob-tangle)
;; (setq org-babel-tangle-lang-exts '(("yaml" . "yaml")))
;; ;; (setq org-babel-tangle-comment-format-beg "[[%s][%s]]")
;; (setq org-babel-tangle-comment-format-beg (format "[[file:%s][%%s]]" (buffer-file-name)))
;; (setq org-babel-tangle-comment-format-beg "[[file:%s][%S]]")
;; (setq org-babel-tangle-comment-format-beg "[[file:%F][%s]]")
;; (setq org-babel-tangle-comment-format-beg "# -*- not delete this comment -*- tangle:%s -*- %s")
;; (setq org-babel-tangle-comment-format-end "")
;; (setq org-babel-detangle-snippets-dir nil)

;; (defun my/get-absolute-org-path ()
;;   "Get absolute path to current org file"
;;   (when (buffer-file-name)
;;     (expand-file-name (buffer-file-name))))

;; (defun my/org-babel-tangle-comment-format ()
;;   "Generate comment format with absolute path"
;;   (let ((abs-path (my/get-absolute-org-path)))
;;     (setq org-babel-tangle-comment-format-beg
;;           (format "[[file:%s][%%s]]" abs-path))))

;; (add-hook 'org-mode-hook #'my/org-babel-tangle-comment-format)
;; (setq org-babel-tangle-debug t)
;; (setq debug-on-error t)

;; (defun my/org-babel-tangle-config ()
;;   "Set comment format with current org file path"
;;   (setq org-babel-tangle-comment-format-beg
;;         (concat "[[file:" (file-relative-name (buffer-file-name)) "][%s]]")))

;; (add-hook 'org-mode-hook #'my/org-babel-tangle-config)

;; (defun my/org-babel-tangle-comment-format ()
;;   "Generate dynamic comment format for org-babel tangle with proper path handling"
;;   (let* ((org-file (buffer-file-name))
;;          (project-root "~/kyrrex/DevOps/")  ; Базовая директория проекта
;;          (relative-org (file-relative-name org-file project-root)))
;;     (setq org-babel-tangle-comment-format-beg
;;           (format "# Source: %s\n# Block: %%s" relative-org))))

;; (add-hook 'org-mode-hook #'my/org-babel-tangle-comment-format)

;; (defun my/org-babel-comment-formatter (lang src-file source-name comment)
;;   "Custom comment formatter for org-babel tangle"
;;   (let ((relative-path (file-relative-name src-file)))
;;     (format "Source: %s\nBlock: %s"
;;             relative-path
;;             (or comment "No description"))))

;; (setq org-babel-tangle-comment-format-function #'my/org-babel-comment-formatter)

;; (setq org-edit-src-window-setup 'reorganize-frame)
;; (setq org-edit-src-content-indentation 0)
;; (setq org-src-window-setup 'split-window-below)
;; (setq org-src-window-setup 'other-window)
;; (setq split-window-preferred-function
;;       (lambda (window)
;;         (let ((new-window (split-window-below
;;                           (round (* 0.8 (window-height window))))))
;;           new-window)))

;; (setq org-src-window-setup 'other-frame)

;;; frame-workspace.el --- Save and restore frame configurations

;;; Commentary:
;; This package provides functionality to save current frame configurations
;; including positions, sizes, and active buffers to a file, and restore them later.
;;
;; Usage:
;;   M-x my/save-frames-workspace  - Save current frames to a file
;;   M-x my/restore-frames-workspace - Restore frames from a file
;;
;; Keybindings (suggested):
;;   (global-set-key (kbd "C-c w s") 'my/save-frames-workspace)
;;   (global-set-key (kbd "C-c w r") 'my/restore-frames-workspace)

;;; Code:

(defun my/get-frame-info (frame)
  "Get information about FRAME including position, size, and current buffer.
Returns a plist with frame parameters and buffer information."
  (with-selected-frame frame
    (let* ((params (frame-parameters frame))
           (current-buffer (current-buffer))
           (buffer-file (buffer-file-name current-buffer))
           (buffer-name (buffer-name current-buffer)))
      (list :name (or (frame-parameter frame 'name) "Emacs")
            :left (or (cdr (assq 'left params)) 0)
            :top (or (cdr (assq 'top params)) 0)
            :width (frame-width frame)
            :height (frame-height frame)
            ;; Buffer information
            :buffer-file buffer-file
            :buffer-name buffer-name
            :buffer-is-file (not (null buffer-file))))))

(defun my/save-frames-workspace ()
  "Save current frame configuration to a file.
Prompts for file location and saves all frames with their positions,
sizes, and active buffers."
  (interactive)
  (let* ((default-file (expand-file-name "emacs-workspace.el" user-emacs-directory))
         (file (read-file-name "Save workspace to: "
                               user-emacs-directory
                               default-file
                               nil
                               "emacs-workspace.el"))
         (frames-info (mapcar #'my/get-frame-info (frame-list))))

    ;; Write to file
    (with-temp-file file
      (insert ";;; Emacs Frame Workspace Configuration\n")
      (insert ";;; Generated: " (current-time-string) "\n\n")
      (insert ";; Frame configurations\n")
      (insert "(setq saved-frames-config\n")
      (insert "  '(\n")
      (dolist (frame-info frames-info)
        (insert "    ")
        (prin1 frame-info (current-buffer))
        (insert "\n"))
      (insert "  ))\n"))

    (message "Workspace saved to: %s (%d frames)"
             file
             (length frames-info))))

(defun my/restore-frame (frame-info)
  "Restore a single frame from FRAME-INFO plist.
Creates a new frame with specified parameters and opens the buffer."
  (let* ((name (plist-get frame-info :name))
         (left (plist-get frame-info :left))
         (top (plist-get frame-info :top))
         (width (plist-get frame-info :width))
         (height (plist-get frame-info :height))
         (buffer-file (plist-get frame-info :buffer-file))
         (buffer-name (plist-get frame-info :buffer-name))
         (buffer-is-file (plist-get frame-info :buffer-is-file))
         ;; Create frame parameters
         (frame-params `((name . ,name)
                        (left . ,left)
                        (top . ,top)
                        (width . ,width)
                        (height . ,height))))

    ;; Create the frame
    (let ((new-frame (make-frame frame-params)))
      (with-selected-frame new-frame
        (cond
         ;; If it was a file buffer, try to open it
         ((and buffer-is-file buffer-file)
          (if (file-exists-p buffer-file)
              (find-file buffer-file)
            (message "Warning: File not found: %s (creating empty frame)" buffer-file)))

         ;; If it was a special buffer (like *scratch*), try to switch to it
         ((get-buffer buffer-name)
          (switch-to-buffer buffer-name))

         ;; Otherwise create empty frame (stays with default buffer)
         (t
          (message "Buffer '%s' not available (empty frame created)" buffer-name))))

      new-frame)))

(defun my/restore-frames-workspace ()
  "Restore frame configuration from a file.
Prompts for file location and restores all saved frames."
  (interactive)
  (let* ((default-file (expand-file-name "emacs-workspace.el" user-emacs-directory))
         (file (read-file-name "Restore workspace from: "
                               user-emacs-directory
                               default-file
                               t
                               "emacs-workspace.el")))

    (unless (file-exists-p file)
      (error "Workspace file does not exist: %s" file))

    ;; Load the file
    (load-file file)

    ;; Check if configuration was loaded
    (unless (boundp 'saved-frames-config)
      (error "Invalid workspace file: no configuration found"))

    ;; Restore frames
    (let ((restored-count 0))
      (dolist (frame-info saved-frames-config)
        (condition-case err
            (progn
              (my/restore-frame frame-info)
              (setq restored-count (1+ restored-count)))
          (error
           (message "Error restoring frame: %s" (error-message-string err)))))

      (message "Workspace restored: %d frames created" restored-count)

      ;; Cleanup
      (makunbound 'saved-frames-config))))

;; Suggested keybindings (uncomment to use):
(global-set-key (kbd "C-c w s") 'my/save-frames-workspace)
(global-set-key (kbd "C-c w r") 'my/restore-frames-workspace)

(defun my/preview-markdown-in-quicklook ()
  "Open current markdown file in QuickLook (using QLMarkdown extension)."
  (interactive)
  (let ((file (buffer-file-name)))
    (if (and file (file-exists-p file))
        (progn
          ;; Сохраняем буфер если есть изменения
          (when (buffer-modified-p)
            (save-buffer))
          ;; Открываем через QuickLook
          ;; Используем /usr/bin/qlmanage напрямую
          (call-process "/usr/bin/qlmanage" nil 0 nil "-p" file))
      (message "Buffer is not visiting a file"))))

(global-set-key (kbd "C-c w m") 'my/preview-markdown-in-quicklook)

(defun my/load-eks-kubeconfig ()
  "Читаем зашифрованный kubeconfig и кладём в env var."
  (interactive)
  (let ((content (shell-command-to-string
                  "gpg --decrypt --pinentry-mode loopback ~/.kube/config.gpg 2>/dev/null")))
    (if (string-match-p "apiVersion" content)
        (progn
          (setenv "KUBECONFIG_CONTENT" content)
          (message "EKS kubeconfig загружен (%d символов)" (length content)))
      (message "⚠️ Ошибка расшифровки — проверь gpg агент"))))
;; Вызов при старте или вручную через M-x
;; (my/load-eks-kubeconfig)  ; раскомментируй если хочешь автоматически

;; Хук на запуск shell/eshell из Emacs
(add-hook 'shell-mode-hook #'my/load-eks-kubeconfig)
(add-hook 'eshell-mode-hook #'my/load-eks-kubeconfig)
(add-hook 'eshell-mode-hook #'eat-eshell-mode)
(add-hook 'shell-mode-hook #'eat-eshell-mode)
(add-hook 'eshell-first-time-mode-hook #'eat-eshell-mode)

(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'multiline2)
  :custom-face
  (eshell-git-prompt-multiline2-dir-face ((t (:weight ultra-bold :foreground "grey")))))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (XXX-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; =================================================================
;; Ghost Cursor: Flash typed characters with inverted colors
;; =================================================================
(defvar my-ghost-cursor-overlay nil
  "Holds the temporary overlay for the ghost cursor.")

(defun my-flash-ghost-cursor ()
  "Leave a temporary, inverted cursor box on the character just typed."
  (when (or (eq this-command 'self-insert-command)
              (eq this-command 'org-self-insert-command))
      ;; Clean up the previous ghost if typing fast
      (when (overlayp my-ghost-cursor-overlay)
        (delete-overlay my-ghost-cursor-overlay))
  ;; (when (eq this-command 'self-insert-command)
  ;;   ;; Clean up the previous ghost if typing fast
  ;;   (when (overlayp my-ghost-cursor-overlay)
  ;;     (delete-overlay my-ghost-cursor-overlay))

    (let ((prev-pos (max (point-min) (1- (point)))))
      (setq my-ghost-cursor-overlay (make-overlay prev-pos (point)))

      ;; Dynamically fetch your theme's exact cursor and background colors
      (let ((cursor-bg (or (face-background 'cursor nil t) "white"))
            (editor-bg (or (face-background 'default nil t) "black")))

        ;; Apply the inverted color scheme to the overlay
        (overlay-put my-ghost-cursor-overlay 'face
                     `(:background ,cursor-bg :foreground ,editor-bg)))

      ;; Make the ghost cursor disappear after 0.15 seconds
      (run-at-time 0.15 nil
                   (lambda (ov)
                     (when (overlayp ov)
                       (delete-overlay ov)))
                   my-ghost-cursor-overlay))))

;; Attach the script to run automatically after every command
(add-hook 'post-command-hook #'my-flash-ghost-cursor)

(set-frame-parameter nil 'alpha-background 66)              ; make current frame transparent
(add-to-list 'default-frame-alist '(alpha-background . 66)) ; make new frames transparent
(defun my/toggle-window-transparency ()
  "Toggle current frame's background transparency."
  (interactive)
  (let* ((desired-alpha 66)
         (current-alpha (frame-parameter nil 'alpha-background)))
    (if (equal current-alpha desired-alpha)
        (progn
          (set-frame-parameter nil 'alpha-background nil)
          (setq default-frame-alist (assq-delete-all 'alpha-background default-frame-alist)))
      (progn
        (set-frame-parameter nil 'alpha-background desired-alpha)
        (add-to-list 'default-frame-alist '(alpha-background . 66))))))

;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name
;;         "straight/repos/straight.el/bootstrap.el"
;;         (or (bound-and-true-p straight-base-dir)
;;             user-emacs-directory)))
;;       (bootstrap-version 7))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; (use-package reader
;;   :straight '(reader :type git :host codeberg :repo "divyaranjan/emacs-reader"
;;                :files ("*.el" "render-core.dylib")
;;                :pre-build ("make" "all")))

(require 'server)
(setq server-auth-dir "~/server-emacs")
(unless (server-running-p)
 (server-start))
;; Local Variables:
;; eval: (add-hook 'after-save-hook (lambda ()(org-babel-tangle)) nil t)
;; End:
;;; init.el ends here
;; (put 'upcase-region 'disabled nil)

;; ;;(byte-recompile-directory package-user-dir nil 'force)
;; (put 'narrow-to-page 'disabled nil)
