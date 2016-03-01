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
(defpackage hash-collector.password-hashes
  (:use :cl
        :hash-collector.util
        :hash-collector.config)
  (:import-from :ironclad
                :digest-sequence
                :ascii-string-to-byte-array)
  (:export :<password-hashes>
           :plaintext
           :md5
           :sha256
           :create-password-hashes))
(in-package :hash-collector.password-hashes)

(defclass <password-hashes> ()
  ((plaintext
    :initform (error "Must supply plaintext!")
    :initarg :plaintext
    :reader plaintext)
   (md5
    :initform nil)
   (sha256
    :initform nil)))
(defgeneric (setf md5) (value obj)
  (:documentation "Setter for the slot \"md5\""))
(defmethod (setf md5) ((value vector) (obj <password-hashes>))
  "Setter for the md5 slot of a password-hashes object."
  (with-slots (md5) obj
    (setf md5 (vector-to-string value))))
(defmethod (setf md5) ((value string) (obj <password-hashes>))
  "Setter for the md5 slot of a password-hashes object."
  (with-slots (md5) obj
    (setf md5 string)))
(defgeneric md5 (obj)
  (:documentation "Getter for a md5 slot."))
(defmethod md5 ((obj <password-hashes>))
  "Getter for the md5 slot of a password-hashes object."
  (slot-value obj 'md5))

(defgeneric (setf sha256) (value obj)
  (:documentation "Setter for a sha256 slot."))
(defmethod (setf sha256) ((value vector) (obj <password-hashes>))
  "Setter for the sha256 slot of a password-hashes object."
  (with-slots (sha256) obj
    (setf sha256 (vector-to-string value))))
(defmethod (setf sha256) ((value string) (obj <password-hashes>))
  "Setter for the sha256 slot of a password-hashes object."
  (with-slots (sha256) obj
    (setf sha256 string)))
(defgeneric sha256 (obj)
  (:documentation "Getter for a sha256 slot."))
(defmethod sha256 ((obj <password-hashes>))
  "Getter for the sha256 slot of a password-hashes object."
  (slot-value obj 'sha256))

(defun create-password-hashes (str)
  "Password-hashes factory. Uses STR as the PLAINTEXT slot."
  (let ((pw-hashes (make-instance '<password-hashes>
                                  :plaintext str)))
    (setf (md5 pw-hashes)
          (digest-sequence
           :md5
           (ascii-string-to-byte-array
            str)))
    (setf (sha256 pw-hashes)
          (digest-sequence
           :sha256
           (ascii-string-to-byte-array
            str)))
    pw-hashes))
