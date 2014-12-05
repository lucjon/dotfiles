(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" default)))
 '(font-use-system-font t)
 '(pr-faces-p t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; **********************
;; Set up package system
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Various display & editing options
(set-default-font "-unknown-Latin Modern Mono Light-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1")
(set-face-attribute 'default nil :height 100)

(setq column-number-mode t)
(setq show-paren-delay 0)
(setq fill-column 80)
(setq tab-width 4)
(setq make-backup-files nil)
(show-paren-mode 1)
(tool-bar-mode -1)
(global-linum-mode t)
(define-key text-mode-map (kbd "TAB") 'indent-relative)

(add-hook 'lisp-mode-hook
	  (lambda ()
	    (set (make-local-variable 'lisp-indent-function)
		 'common-lisp-indent-function)))

;; Load SLIME
(add-to-list 'load-path "~/src/slime")
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/clisp")
(add-to-list 'slime-contribs 'slime-repl)
(add-to-list 'slime-contribs 'slime-autodoc)

;; Some evil bindings to emulate my old vim config
(require-package 'evil)
(load "evil")
(define-key evil-normal-state-map "\C-H" 'evil-window-left)
(define-key evil-normal-state-map "\C-J" 'evil-window-down)
(define-key evil-normal-state-map "\C-K" 'evil-window-up)
(define-key evil-normal-state-map "\C-L" 'evil-window-right)
(evil-mode)
