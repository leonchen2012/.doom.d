;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Mark Chen"
      user-mail-address "leonchen8012@hotmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Workspace/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq
 ;; doom-font (font-spec :family "Iosevka Term SS04" :size 24 :weight 'light)
 ;; doom-big-font (font-spec :family "Iosevka Term SS04" :size 36)
 ;; doom-variable-pitch-font (font-spec :family "SF Pro Text")
 ;;doom-font (font-spec :family "SF Mono" :size 20)
 projectile-project-search-path '("~/Workspace/")
 org-log-done 'time
 org-agenda-files (directory-files-recursively "~/Workspace/org/" "\\.org$")
 org-agenda-skip-scheduled-if-done t)

;;(setq doom-font (font-spec :family "Sarasa Term SC Nerd" :size 18)
;;      doom-variable-pitch-font (font-spec :family "Sarasa Term SC Nerd")
;;      doom-symbol-font (font-spec :family "Sarasa Term SC Nerd")
;;      doom-big-font (font-spec :family "Sarasa Term SC Nerd" :size 22))
;;
(when (eq system-type 'darwin)
      (setq fonts '("Fira Code" "LXGW WenKai Mono"))
      (set-face-attribute 'default nil :font
                        (format "%s:pixelsize=%d" (car fonts) 16)))
      ;;(setq face-font-rescale-alist '(("LXGW WenKai Mono". 1.2))))

(when (eq system-type 'windows-nt)
      (setq fonts '("Inconsolata" "华文楷体"))
      (set-face-attribute 'default nil :font
                        (format "%s:pixelsize=%d" (car fonts) 20))
      (setq face-font-rescale-alist '(("华文楷体". 1.0))))

(when (eq system-type 'gnu/linux)
      (setq fonts '("Inconsolata" "STKaiti"))
      (set-face-attribute 'default nil :font
                        (format "%s:pixelsize=%d" (car fonts) 18))
      (setq face-font-rescale-alist '(("STKaiti". 1.0))))

(dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font) charset
                        (font-spec :family (car (cdr fonts)))))


(after! org
  ;; disable auto-complete in org-mode buffers
  (remove-hook 'org-mode-hook #'auto-fill-mode)
  ;; disable company too
  (setq company-global-modes '(not org-mode))
  ;; ...
  )

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/Workspace/org"))
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c c" . org-roam-dailies-capture-today)) ;; used mostly
  :config
  (require 'org-roam-dailies)
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (org-roam-db-autosync-mode))

(use-package! vulpea
  :after org-roam
  :config
;;  (load! "roam-agenda") ;; a separate file containing the gist in my private doom directory

  ;; prevent headings from clogging tag
  (add-to-list 'org-tags-exclude-from-inheritance "project"))

(setq projectile-sort-order 'recently-active
      projectile-switch-project-action #'projectile-dired)

;; global beacon minor-mode
(use-package! beacon)
(after! beacon (beacon-mode 1))

(setq lsp-julia-package-dir nil)
(use-package! lsp-julia
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.9"))

;; 在其他应用程序中打开相关文件
(use-package! dired-open
  :after dired
  :custom
  (dired-open-functions (list #'dired-open-guess-shell-alist
                              #'dired-open-by-extension
                              #'dired-open-subdir))
  (dired-guess-shell-alist-user '(("\\.\\(?:docx\\|djvu\\|eps\\)\\'" "xdg-open")
                                  ("\\.\\(?:\\|gif\\|xpm\\)\\'" "xdg-open")
                                  ("\\.\\(?:xcf\\)\\'" "xdg-open")
                                  ("\\.csv\\'" "xdg-open")
                                  ("\\.tex\\'" "xdg-open")
                                  ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\|mov\\)\\(?:\\.part\\)?\\'" "xdg-open")
                                  ("\\.\\(?:mp3\\|flac\\)\\'" "xdg-open")
                                  ("\\.html?\\'" "xdg-open")
                                  ("\\.md\\'" "xdg-open"))))
(use-package! dired-subtree
  :after dired)

(after! dired
  (setq dired-dwim-target #'dired-dwim-target-recent))

;; set julia threads to 12
(setenv "JULIA_NUM_THREADS" "12")
(set-language-environment "UTF-8")

;; chinese sentence word wrapping
(setq word-wrap-by-category t)

;; Not needed if your input sources are the same with the default values
(sis-ism-lazyman-config
 "com.apple.keylayout.US"
 "com.apple.inputmethod.SCIM.ITABC")
(use-package sis
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :config
  ;; For MacOS
  (sis-ism-lazyman-config

   ;; English input source may be: "ABC", "US" or another one.
   ;; "com.apple.keylayout.ABC"
   "com.apple.keylayout.US"

   "com.apple.inputmethod.SCIM.ITABC")
   ;; Other language input source: "rime", "sogou" or another one.
   ;; "im.rime.inputmethod.Squirrel.Rime"

  ;; enable the /cursor color/ mode
  ;;(sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )
