(add-to-list 'load-path "~/.emacs.d/cedet-1.1/common")
(add-to-list 'load-path "~/.emacs.d/cedet-1.1/")
(load-file "~/.emacs.d/cedet-1.1/common/cedet.elc")
;;(require 'cedet)

;;加载各种mode
;;(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;;(semantic-load-enable-guady-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
;;(global-set-key [f4] 'speedbar)

;;增加寻找头文件的路径(仅限于c和c++)
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public" 
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
   (mapc (lambda (dir)
           (semantic-add-system-include dir 'c++mode)
           (semantic-add-system-include dir 'c-mode))
         include-dirs))

;;代码跳转 f12从函数名跳转到定义处 S-f12返回 M-S-f12函数的声明和实现间跳转(声明和实现间跳转仅限于c和c++)
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
(define-key c-mode-base-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)

;;书签 f2设置或取消书签 C-f2查找下一个书签 S-f2查找上一个书签 C-S-f2清空所有书签
(enable-visual-studio-bookmarks)

;;h/cpp切换(仅限于c和c++)
(require 'eassit nil 'noerror)
(define-key c-mode-base-map [M-f12] 'eassist-switch-h-cpp)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))

;;代码折叠 在终端下M-x senator-fold-tag
(if (window-system) 
    (progn
      (require 'semantic-tag-folding nil 'noerror)
      (global-semantic-tag-folding-mode 1)
      (global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)
      (define-key semantic-tag-folding-mode-map (kbd "C-c , -") 'semantic-tag-folding-fold-block)
      (define-key semantic-tag-folding-mode-map (kbd "C-c , +") 'semantic-tag-folding-show-block)
      (define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-all)
      (define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-all)))

;;高亮显示变量名
(add-to-list 'load-path "~/.emacs.d/highlight-symbol")
(require 'highlight-symbol)
(global-set-key [C-f3] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [S-f3] 'highlight-symbol-prev)

;;自动补全
(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol)
(if (window-system)
    (progn
      (define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)))
;;(define-key c-mode-base-map [(tab)] 'dabbrev-expand)
;;company-mode自动补全
;;(add-to-list 'load-path "~/.emacs.d/company")
;;(require 'company)
;;(global-company-mode t)
;;(setq company-idle-delay 0.2)
;;(setq company-minimum-prefix-length 1)
;;auto-complete
(add-to-list 'load-path "/home/guwanli/.emacs.d/auto-complete") 
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
(ac-config-default)
;;增强
;;(require 'pos-tip)
;;(setq ac-quick-help-prefer-pos-tip t)   ;default is t
;;显示帮助（默认也是打开的）
;;(setq ac-use-quick-help t)
;;(setq ac-quick-help-delay 1.0)
;;定义tab键
;;(setq ac-dwim t)
;;关闭自动触发
;;(setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
;;(ac-set-trigger-key "<C-return>")
;;定义删除键触发
;;(setq ac-trigger-commands
;;      (cons 'backward-delete-char-untabify ac-trigger-commands))
;;模糊匹配
;;(setq ac-fuzzy-enable t)

;;EDE
;;(global-ede-mode t)
;;(load-file "~/.emacs.d/cedet-1.1/ede/ede.elc")
;;ECB
(add-to-list 'load-path
    "~/.emacs.d/ecb-2.40")
(require 'ecb)
;;(require 'ecb-autoloads)
(setq stack-trace-on-error nil)
;;(setq ecb-auto-activate t
;;      ecb-tip-of-the-day nil)

;;Yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
(require'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")

;;c和c++定制
(defun my-c-mode-common-hook()
  (c-set-style "stroustrup")
  ;;(c-set-style "k&r")
  (c-toggle-hungry-state t))  
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;设定return为C-j c/c++和python
(define-key c-mode-base-map [(return)] 'newline-and-indent)
(add-hook 'python-mode-hook
	  '(lambda ()
	     (define-key python-mode-map [(f5)] 'run-python)
	     ;;(define-key python-mode-map [(tab)] 'dabbrev-expand)
	     (define-key python-mode-map [(return)] 'newline-and-indent)))

;;python定制

;;编译 "比较智能的C/C++编译命令如果当前目录有makefile则用make -k编译，否则，如果是处于c-mode，就用gcc -Wall编译，如果是c++-mode就用g++ -Wall编译" 
(global-set-key (kbd "<f9>") 'smart-compile)
(defun smart-compile()
  (interactive)
  ;;查找 Makefile
  (let ((candidate-make-file-name '("makefile" "Makefile" "GNUmakefile"))
        (command nil))
    (if (not (null
              (find t candidate-make-file-name :key
                    '(lambda (f) (file-readable-p f)))))
        (setq command "make -k ")
        ;; 没有找到 Makefile ，查看当前 mode 是否是已知的可编译的模式
        (if (null (buffer-file-name (current-buffer)))
            (message "Buffer not attached to a file, won't compile!")
            (if (eq major-mode 'c-mode)
                (setq command
                      (concat "gcc -Wall -o "
                              (file-name-sans-extension
                               (file-name-nondirectory buffer-file-name))
                              " "
                              (file-name-nondirectory buffer-file-name)
                              " -g -lm "))
	      (if (eq major-mode 'c++-mode)
                  (setq command
                        (concat "g++ -Wall -o "
                                (file-name-sans-extension
                                 (file-name-nondirectory buffer-file-name))
                                " "
                                (file-name-nondirectory buffer-file-name)
                                " -g -lm "))
                (message "Unknow mode, won't compile!")))))
    (if (not (null command))
        (let ((command (read-from-minibuffer "Compile command: " command)))
          (compile command)))))
(define-key c-mode-base-map [f8] 'c-c++-run)
(defun c-c++-run()
  (interactive)
  (split-window-horizontally)
  (setq cmd
	(concat "./"
		(file-name-sans-extension
		 (file-name-nondirectory buffer-file-name))
		))
  (next-multiframe-window)
  (shell)
  (insert cmd))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes nil)
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
;;调试C/C++
(add-hook 'gdb-mode-hook '(lambda ()
                            (define-key c-mode-base-map [(f5)] 'gud-go)
                            (define-key c-mode-base-map [(f6)] 'gud-step)
                            (define-key c-mode-base-map [(f7)] 'gud-next)))
(setq gdb-many-windows t)

;;LaTex
;;
(mapc (lambda (mode)
      (add-hook 'LaTeX-mode-hook mode))
      (list 'auto-fill-mode
            'LaTeX-math-mode
            'turn-on-reftex
            'linum-mode))
;;
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-auto-untabify t)     ; remove all tabs before saving
                  ;TeX-engine 'xetex       ; use xelatex default
                  ;TeX-show-compilation t) ; display compilation windows
            (TeX-global-PDF-mode t)       ; PDF mode enable, not plain
            (setq TeX-save-query nil)
            (imenu-add-menubar-index)
            (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))
;(setq LaTeX-document-regexp "document//|CJK//*?") ;; CJK 环境中不缩进 
;(setq TeX-newline-function 'newline-and-indent) ;;回车时自动缩进 
;;
;;(setq TeX-view-program-list
;;      '(("SumatraPDF "SumatraPDF.exe %o")))
;;
(setq TeX-view-program-list
      '(("SumatraPDF" "SumatraPDF.exe %o")
        ("Gsview" "gsview32.exe %o")
        ("Okular" "okular --unique %o")
        ("Evince" "evince %o")
        ("Firefox" "firefox %o")))
;;
(cond 
 ((eq system-type 'gnu/linux)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "Evince")
                                                 (output-dvi "Evince")))))))