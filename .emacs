;; Andrew's .emacs  -*- mode:emacs-lisp -*-
;; This is for GNU Emacs 23+ on various machines

;;(setq debug-on-error t)

(setq system-name
      (downcase (replace-regexp-in-string "\\..*$" "" system-name)))
(setq frame-title-format
      (concat "%b - emacs@" system-name))

(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(add-to-list 'load-path (expand-file-name "~/lisp"))
(add-to-list 'exec-path (expand-file-name "~/bin"))
(add-to-list 'Info-default-directory-list (expand-file-name "~/info"))

;;(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)
(global-set-key "\C-x\C-b" 'bs-show)
(global-set-key [C-tab] 'bs-cycle-next)
(global-set-key [S-tab] 'bs-cycle-previous)
(global-set-key "\C-x\ f" 'find-file)
;;(global-set-key (kbd "RET") 'newline-and-indent)
(defalias 'qrr 'query-replace-regexp)

(set-language-environment "Latin-1")
(prefer-coding-system 'utf-8-unix)

(cd "~")

(global-font-lock-mode 1)

(server-start)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Org

(add-to-list 'load-path (expand-file-name "~/lisp/org/lisp"))
(add-to-list 'load-path (expand-file-name "~/lisp/org/contrib/lisp"))
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done 'time)
(setq org-agenda-files '("~/org"))
;;(setq org-export-with-LaTeX-fragments t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ditaa . t)
   (dot . t)))

(setq org-directory "~/org")
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; iedit

(when (locate-library "iedit")
  (autoload 'iedit-mode "iedit" "Toggle iedit mode." t) 
  (define-key global-map (kbd "C-;") 'iedit-mode))

;; Machine-specific settings
;; Stuff on other systems:
;; windows-nt:

;;; TODO: 
;;; check whether font exists with 'font-info' and/or 'fontp'

(cond
 ((string= system-type "windows-nt")
  (setq default-frame-alist '(( font . "Anonymous Pro-8" )))
  (setq tramp-default-method "plinkx")))

(cond
 ((string= window-system "ns")
  (setq default-frame-alist '(( font . "Anonymous Pro-12" )))))

(add-to-list 'exec-path "/usr/local/bin")
(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))

(setenv "MANPATH" "/usr/share/man:/usr/local/share/man:/usr/X11/man")

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))

(setq-default eol-mnemonic-mac "(\\r)"
	      eol-mnemonic-unix "(\\n)"
	      eol-mnemonic-dos "(\\r\\n)"
	      eol-mnemonic-undecided "(?)")

;; Open SAR like JAR/WAR/EAR -- i.e., as zip

(add-to-list 'auto-mode-alist '("\\.sar$" . archive-mode))

;; 4-space tab stops, and always use spaces.

(setq-default indent-tabs-mode nil)
(define-key text-mode-map (kbd "TAB") 'tab-to-tab-stop)
(setq tab-stop-list (number-sequence 4 160 4))

;; Generic

(setq generic-define-mswindows-modes t)
(setq generic-define-unix-modes t)
(require 'generic-x)

(add-to-list 'auto-mode-alist '("httpd.*conf" . apache-conf-generic-mode))
(add-to-list 'auto-mode-alist '("\\.properties" . java-properties-generic-mode))

;; Java

(defun my-java-mode-hook ()
  (c-set-offset 'arglist-intro 'c-basic-offset)
  (c-set-offset 'arglist-close 'c-lineup-close-paren))
(add-hook 'java-mode-hook 'my-java-mode-hook)

;; Scala

(add-to-list 'load-path (expand-file-name "~/lisp/scala"))
(when (locate-library "scala-mode-auto")
  (require 'scala-mode-auto))
(add-to-list 'load-path (expand-file-name "~/lisp/ensime/elisp"))
(when (locate-library "ensime")
  (require 'ensime))
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Perl, if we must

(defalias 'perl-mode 'cperl-mode)
(setq cperl-hairy t)

;; JAD

(when (locate-library "decomp")
  (load-library "decomp"))

;; Javascript

(when (locate-library "js2")
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (autoload 'js2-mode "js2" "Major mode for editing JavaScript code." t))

;; StringTemplate

(when (locate-library "stringtemplate-mode")
  (autoload 'stringtemplate-mode "stringtemplate-mode"
    "Major mode for editing StringTemplate files" t))

;; SQL

(setq sql-product (quote db2))
(add-to-list 'auto-mode-alist '("\\.\\(tbl\\|trg\\)$" . sql-mode))

;; Windows

(when (eq system-type 'windows-nt)
  (let ((cygwin-bin (car (prune-directory-list '("C:/cygwin/bin" "Z:/cygwin/bin")))))
    (setq w32-enable-synthesized-fonts t)
    (when cygwin-bin
      (setq w32shell-cygwin-bin cygwin-bin)
      (when (locate-library "cygwin-mount")
	(load-library "cygwin-mount")
	(setq cygwin-mount-cygwin-bin-directory cygwin-bin)
	(cygwin-mount-activate)
	(add-to-list 'Info-default-directory-list "/usr/info/")
	(add-to-list 'Info-default-directory-list "/usr/local/info/")
	(add-to-list 'Info-default-directory-list "/usr/share/info/")
	(setq exec-path (cons cygwin-bin exec-path))
	(setenv "PATH" (concat
			(replace-regexp-in-string "/" "\\\\" cygwin-bin)
			";"
			(getenv "PATH")))
	(setq shell-file-name "bash")
	(setenv "SHELL" shell-file-name) 
	(setq explicit-shell-file-name shell-file-name) 
	(add-hook 'comint-output-filter-functions
		  'comint-strip-ctrl-m)))))

(when (locate-library "cmd-mode")
  (autoload 'cmd-mode "cmd-mode" "CMD mode." t)
  (add-to-list 'auto-mode-alist '("\\.\\(cmd\\|bat\\)$" . cmd-mode)))

;; nXML

(when (locate-library "nxml-colors")
  (load-library "nxml-colors"))

(push '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\|plist\\|wsdl\\)$" . nxml-mode) auto-mode-alist)
(push '("\\`<\\?xml" . nxml-mode) magic-mode-alist)
(require 'rng-loc)
(setq rng-schema-locating-files
      (cons (car rng-schema-locating-files-default)
	    (cons "~/lisp/schemas/schemas.xml"
		  (cdr rng-schema-locating-files-default))))

;; RNC

(when (locate-library "rnc-mode")
  (autoload 'rnc-mode "rnc-mode")
  (add-to-list 'auto-mode-alist '("\\.rnc$" . rnc-mode)))

;; Menu item for linum-mode

(define-key-after menu-bar-options-menu [line-numbering]
  '(menu-item "Line Numbering in this Buffer"
	      (lambda ()
		(interactive)
		(linum-mode 'toggle))
	      :button (:toggle . (and (boundp 'linum-mode)
				      linum-mode)))
  'line-wrapping)

;; Menu item for whitespace-mode

(define-key-after menu-bar-options-menu [show-whitespace]
  '(menu-item "Show Whitespace in this Buffer"
	      (lambda ()
		(interactive)
		(whitespace-mode 'toggle))
	      :button (:toggle . (and (boundp 'whitespace-mode)
				      whitespace-mode)))
  'line-numbering)

;; taken from: http://nolan.eakins.net/node/208

(defun just-spaces-or-empty ()
  "Returns true if the current line is empty."
  (progn (beginning-of-line)
	 (looking-at "[ \t]*$")))

(defalias 'line-empty? 'just-spaces-or-empty)

(require 'cl)

(defun unfill-region (min max)
  "Joins the lines in the paragraphs inside a
region defined by MIN and MAX. If this is called
interactively then the mark and point are used to
define the region."
  (interactive (list (mark)
		     (point)))
  (if (> min max)
      (let ((temp min))
	(setq min max)
	(setq max temp)))
  (goto-char min)
  (message (format "%d %d" min max))
  (let ((empty nil))
    (message "Unfilling...")
    (loop with end = min
	  always (< end max)
	  do
	  (setq end (line-end-position))
	  (setq empty (line-empty?))
	  (next-line 1)
	  (if (not empty)
	      (if (not (line-empty?))
		  (join-line))))
    (message "Unfilled")))

(defun unfill-buffer ()
  "Joins the lines of all the paragraphs of a buffer."
  (interactive)
  (let ((point (point)))
    (unfill-region (point-min) (point-max))
    (goto-char point)))

;;

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file name new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))


;; Custom-izations

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-list-file-prefix nil)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(blink-cursor-mode nil)
 '(bs-default-configuration "all")
 '(c-echo-syntactic-information-p t)
 '(case-fold-search t)
 '(column-number-mode t)
 '(compile-auto-highlight t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(cperl-font-lock t)
 '(custom-buffer-done-function (quote kill-buffer))
 '(default-major-mode (quote text-mode) t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(even-window-heights nil)
 '(focus-follows-mouse nil)
 '(global-font-lock-mode t nil (font-core))
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(js2-highlight-level 3)
 '(ls-lisp-verbosity (quote (uid)))
 '(mouse-wheel-progressive-speed nil)
 '(nxml-slash-auto-complete-flag t)
 '(org-src-fontify-natively t)
 '(org-src-tab-acts-natively t)
 '(org-startup-folded nil)
 '(recentf-auto-cleanup (quote never))
 '(recentf-filename-handlers (quote (abbreviate-file-name)))
 '(recentf-max-menu-items 20)
 '(recentf-max-saved-items 100)
 '(recentf-mode t nil (recentf))
 '(scroll-bar-mode (quote right))
 '(sentence-end-double-space nil)
 '(show-paren-mode t nil (paren))
 '(size-indication-mode t)
 '(temp-buffer-resize-mode t nil (help))
 '(tool-bar-mode nil nil (tool-bar))
 '(track-eol t)
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-delete-logbuf-window nil)
 '(w32shell-shell (quote cygwin))
 '(woman-fill-frame t)
 '(x-select-enable-clipboard t)
 '(x-stretch-cursor t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "Black")))))

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)
