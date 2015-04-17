;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright (C) 2015 Richard Bäck <richard.baeck@openmailbox.org>
;;
;; This file is part of assets-cli.
;;
;; assets-cli is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; assets-cli is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with assets-cli.  If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package #:hash-collector)

(defvar *letters* *letters-default*)
(defvar *base-path* *base-path-default*)

(defun get-letters ()
  *letters*)

(defun permut (len cur-str callback)
  "Permuts a passwort with given letters and a length declared by LEN. CUR-STR should always be \"\"."
  (declare (fixnum len)
           (string cur-str))
  (if (= len (length cur-str))
      (funcall callback cur-str)
      (progn
        (let ((letter-vector (get-letters))
              (ret-val nil))
          (loop for l across letter-vector do
               (setf ret-val (permut len
                               (concatenate 'string
                                            cur-str
                                            (string l))
                               callback))
               (when (not (null ret-val))
                 (return-from permut ret-val)))))))

(defun create-and-persist-hashes (str)
  (let ((hash (create-password-hashes str)))
    (persist hash))
  nil)

;; (defun call-url (url)
;;   (if (= (nth-value 1 (drakma:http-request (concatenate 'string
;;                                                  *base-path*
;;                                                  url)))
;;            200)
;;       url
;;       nil))

(defun collect (len)
  (connect-db *sqlite-db-path*)
  (permut len "" #'create-and-persist-hashes)
  (disconnect-db))
