;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sahan Reddy"
      user-mail-address "sahan.reddy.58@gmail.com")

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
(setq doom-font (font-spec :family "Iosevka" :size 16 :weight 'normal))
(setq doom-themes-treemacs-enable-variable-pitch nil)
(setq doom-themes-treemacs-theme "doom-colors")
(setq treemacs-collapse-dirs 10)



;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-snazzy)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; No title bar
(add-to-list 'default-frame-alist '(undecorated . t))

;; Focus follows mouse
(setq mouse-autoselect-window t)

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

(map! :nvm ";" #'evil-ex)
(map! :nvm "." #'evil-snipe-repeat)

(map! :g "M-h" #'evil-window-left
      :g "M-j" #'evil-window-down
      :g "M-k" #'evil-window-up
      :g "M-l" #'evil-window-right)
(map! :map 'vterm-mode-map
      :g "M-h" #'evil-window-left
      :g "M-j" #'evil-window-down
      :g "M-k" #'evil-window-up
      :g "M-l" #'evil-window-right)

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! lsp
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd-12")
                    :major-modes '(c-mode c++-mode)
                    :remote? t
                    :server-id 'clangd12-remote)))

(use-package! magit
  :config
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules-overview
                          'magit-insert-unpulled-from-upstream))

(use-package! evil-snipe
  :config
  (setq evil-snipe-spillover-scope 'visible))

;(require 'dap-gdb-lldb)


(setq c-doc-comment-style '((java-mode . javadoc)
                            (pike-mode . autodoc)
                            (c-mode . doxygen)
                            (c++-mode . doxygen)))
(setq evil-ex-substitute-global t)

(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.Dockerfile\\'" . dockerfile-mode))

;(use-package! shx
;  :config
;  (add-hook 'shell-mode-hook 'shx-mode)
;
;  ;(set-popup-rules!
;  ;  '(("^\\*my:shx-popup"  ; editing buffers (interaction required)
;  ;     :vslot -5 :size 0.35 :select t :modeline nil :quit nil :ttl nil)))
;  ;(defun my/shell-toggle (&optional command)
;  ;  "Toggle a persistent terminal popup window.
;
;  ;  If popup is visible but unselected, selected it.
;  ;  If popup is focused, kill it."
;  ;  (interactive)
;  ;  (let ((buffer
;  ;         (get-buffer-create
;  ;          (format "*doom:shell-popup:%s*"
;  ;                  (if (bound-and-true-p persp-mode)
;  ;                      (safe-persp-name (get-current-persp))
;  ;                    "main"))))
;  ;        (dir default-directory))
;  ;    (if-let (win (get-buffer-window buffer))
;  ;        (let (confirm-kill-processes)
;  ;          (set-process-query-on-exit-flag (get-buffer-process buffer) nil)
;  ;          (delete-window win)
;  ;          (ignore-errors (kill-buffer buffer)))
;  ;      (with-current-buffer buffer
;  ;        (if (not (eq major-mode 'shell-mode))
;  ;            (shx buffer)
;  ;          (cd dir)
;  ;          (run-mode-hooks 'shell-mode-hook)))
;  ;      (pop-to-buffer buffer))
;  ;    (when-let (process (get-buffer-process buffer))
;  ;      (set-process-sentinel process #'+shell--sentinel)
;  ;      (+shell--send-input buffer command))))
;  (map! :leader
;        (:prefix-map ("o" . "open")
;         :desc "Open shell here" "T" #'shx)))

(use-package!  bash-completion
  :config
  (bash-completion-setup))

(use-package! xterm-color
  :config
  (setq comint-output-filter-functions
        (remove 'ansi-color-process-output comint-output-filter-functions))
  (setq tramp-terminal-type "xterm-256color")
  (setq compilation-environment '("TERM=xterm-256color"))

  (add-hook 'shell-mode-hook
            (lambda ()
              ;; Disable font-locking in this buffer to improve performance
              (font-lock-mode -1)
              ;; Prevent font-locking from being re-enabled in this buffer
              (make-local-variable 'font-lock-function)
              (setq font-lock-function (lambda (_) nil))
              (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t))))
(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'my/advice-compilation-filter)
(setq-default explicit-shell-file-name "/bin/bash")

(use-package! meson-mode
  :config
  (add-hook 'meson-mode-hook 'company-mode))
