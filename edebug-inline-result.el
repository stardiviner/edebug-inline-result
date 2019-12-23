;;; edebug-inline-result.el --- show Edebug result inline.

;; Authors: stardiviner <numbchild@gmail.com>
;; Package-Requires: ((emacs "25") (cl-lib "0.5"))
;; Package-Version: 0.1
;; Keywords: edebug inline
;; homepage: https://www.github.com/stardivin

;; edebug-inline-result is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; edebug-inline-result is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Time-stamp: <2019-03-14 14:31:24 stardiviner>

;;; Commentary:

;;; TODO: reference `lsp-ui-doc'

;;; Code:

(defgroup edebug-inline-result nil
  "edebug-inline-result options."
  :prefix "edebug-inline-result-"
  :group 'edebug)

;;;###autoload
(defun edebug-inline-result-show ()
  "Show `edebug-previous-result' with specific popup backend."
  (cond
   ((featurep 'posframe)
    (posframe-show " *edebug-previous-result*"
                   :string (substring-no-properties edebug-previous-result)
                   :position (point)
                   :width (window-width)
                   :background-color "DarkCyan"
                   :foreground-color "white"
                   :width 50))
   ((featurep 'popup)
    (popup-tip edebug-previous-result
               :truncate t :height 20 :width 45 :nostrip t :margin 1 :nowait nil))
   ((featurep 'quick-peek)
    (quick-peek-show edebug-previous-result))
   ((featurep 'inline-docs)
    (inline-docs edebug-previous-result))
   ((featurep 'pos-tip)
    (pos-tip-show edebug-previous-result 'popup-face))))

(defun edebug-inline-result--hide-frame ()
  "Hide edebug result child-frame."
  (when (featurep 'posframe)
    (unless (fboundp 'posframe-hide)
      (require 'posframe))
    (posframe-hide " *edebug-previous-result*")))

(defun edebug-inline-result-enable ()
  "Enable `edebug-inline-result-mode'."
  (advice-add 'edebug-previous-result :override #'edebug-inline-result-show)
  (advice-add 'top-level :before #'edebug-inline-result--hide-frame)
  (add-hook 'focus-out-hook #'edebug-inline-result--hide-frame nil t)
  (advice-add 'edebug-next-mode :before #'edebug-inline-result--hide-frame))

(defun edebug-inline-result-disable ()
  "Disable `edebug-inline-result-mode'."
  (advice-remove 'edebug-previous-result #'edebug-inline-result-show)
  (advice-remove 'top-level #'edebug-inline-result--hide-frame)
  (remove-hook 'focus-out-hook #'edebug-inline-result--hide-frame)
  (advice-remove 'edebug-next-mode #'edebug-inline-result--hide-frame))

(defvar edebug-inline-result-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "edebug-inline-result-mode map.")

;;;###autoload
(define-minor-mode edebug-inline-result-mode
  "A minor mode that show Edebug result with inline style."
  :require 'edbeug-inline-result
  :init-value t
  :lighter ""
  :group 'edebug-inline-result
  :keymap 'edebug-inline-result-mode-map
  (if edebug-inline-result-mode
      (edebug-inline-result-enable)
    (edebug-inline-result-disable)))

;;;###autoload
(define-global-minor-mode global-edebug-inline-result-mode edebug-inline-result-mode
  edebug-inline-result-mode)



(provide 'edebug-inline-result)

;;; edebug-inline-result.el ends here
