;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright (C) 2015 Richard Bäck <richard.baeck@openmailbox.org>
;;
;; This file is part of hash-collector.
;;
;; hash-collector is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; hash-collector is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with hash-collector.  If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :cl-user)
(defpackage hash-collector.hash-collector
  (:use :cl
        :hash-collector.password-hashes
        :hash-collector.database)
  (:export :collect))
(in-package :hash-collector.hash-collector)

;; The following variables are parameters. Parameters are variables
;; whose value can't be changed. Those are are used for ultimately
;; fixed values. Using parameters to set variables (defvar) is a good
;; practise to be able to change dynamic global variables in runtime.
(defparameter *letters-default*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
(defparameter *letters-with-numbers*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
(defparameter *letters-german-with-numbers-with-punctuations*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789äöüÄÖÜ.-+?!")

(defvar *letters* *letters-default*)

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
  "Creates a new password-hashes object with STR as the slot PLAINTEXT. Afterwards it is persisted."
  (let ((hash (create-password-hashes str)))
    (persist hash))
  nil)

(defun collect (len)
  "Starts to calculate all hashes for permuted strings with the length LEN."
  (connect-db *sqlite-db-path*)
  (permut len "" #'create-and-persist-hashes)
  (disconnect-db))
