(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (light-blue)))
 '(fill-column 100)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (projectile zenburn-theme yasnippet-snippets yaml-mode which-key undo-tree tabbar session rust-mode puppet-mode pod-mode muttrc-mode mutt-alias lv lsp-ui initsplit ido-completing-read+ htmlize graphviz-dot-mode goto-chg gitignore-mode gitconfig-mode gitattributes-mode git-modes folding ess eproject diminish csv-mode company-lsp browse-kill-ring boxquote bm bar-cursor apache-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(scroll-bar ((t (:background "steel blue" :foreground "spring green")))))

;; Plugins list
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/neotree"))
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/screenwriter-1.6/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/scss-mode/"))

(require 'neotree)
  (global-set-key [f8] 'neotree-toggle)

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; melpa
(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
    '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; ido
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)

;; (setq tags-table-list
      ;; (delete "" (split-string (shell-command-to-string "ls -d ~/c/*/TAGS"))))

;; (defun search-tags ()
  ;; "Find a tag using ido"
  ;; (interactive)
  ;; (tags-completion-table)
  ;; (let (tag-names)
    ;; (mapcar (lambda (x)
              ;; (push (prin1-to-string x t) tag-names))
            ;; tags-completion-table)
    ;; (find-tag (ido-completing-read "Tag: " tag-names))))


;; Rails
;; (require 'flymake-ruby)
;; (add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; (projectile-global-mode) ;; recommended, but idk why...
;; (add-hook 'ruby-mode-hook 'projectile-on)
;; (add-hook 'projectile-mode-hook 'projectile-rails-on)

;; auto-completion in ruby
;; (require 'robe)
;; (add-hook 'ruby-mode-hook 'robe-mode)
;; (add-hook 'ruby-mode-hook 'company-complete)

;; completion stuff
(global-company-mode t)
(push 'company-robe company-backends)

;; (global-set-key (kbd "C-c r r") 'inf-ruby) ;; ruby shell inside emacs

;; comments
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-logical-line)))

(global-set-key (kbd "C-;") 'comment-or-uncomment-region-or-line)
(show-paren-mode 1) ;; highlight other parenthesis
(global-unset-key (kbd "C-z"))

;; fuzzy search file
;; (require 'git-find-file)                           ;; Doesn't work well with submodules
;; (global-set-key (kbd "C-x C-M-f") 'git-find-file)  ;; Doesn't work well with submodules
(projectile-mode +1)
(global-set-key (kbd "C-x C-M-f") 'projectile-command-map)

;; (shell)
;; (defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
;;  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
;;   (flet ((process-list ())) ad-do-it))

;; tabs and spaces
;; (setq js-indent-level 2)

(setq indent-tabs-mode nil) ;; tabs are spaces; comment out to set to tabs

(setq-default fill-column 100)

;; sudo apt-get install emacs-google-config
(require 'google)
(require 'google-cc-extras)
(add-hook 'c++-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'google-clang-format-file nil :local)))

;; buildifier
(add-hook 'after-save-hook
          (lambda()
            (if (string-match "BUILD" (file-name-base (buffer-file-name)))
                (progn
                  (shell-command (concat "buildifier " (buffer-file-name)))
                  (find-alternate-file (buffer-file-name))))))
(put 'downcase-region 'disabled nil)

(add-hook 'python-mode-hook '(lambda ()
                               (setq python-indent 2)))

;; (server-start)
