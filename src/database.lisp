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

(defvar *sqlite-db-path* (concatenate
                          'string
                          (namestring (truename "."))
                          *sqlite-db-path-default*))
(defvar *sqlite-persist-query-password-hashes*
  *sqlite-persist-query-password-hashes-default*)
(defvar *sqlite-get-single-query-password-hashes*
  *sqlite-get-single-query-password-hashes-default*)
(defvar *sqlite-db* nil)

(defun connect-db (filename)
  (setf *sqlite-db*
        (sqlite:connect *sqlite-db-path*)))

(defun disconnect-db ()
  (sqlite:disconnect *sqlite-db*))

(defgeneric is-persisted (obj))
(defmethod is-persisted ((obj password-hashes))
    (sqlite:execute-single
     *sqlite-db*
     *sqlite-get-single-query-password-hashes*
     (plaintext obj)))

(defgeneric persist (obj))
(defmethod persist ((obj password-hashes))
  (when (not (is-persisted obj))
      (sqlite:execute-non-query
       *sqlite-db*
       *sqlite-persist-query-password-hashes*
       (plaintext obj)
       (md5 obj)
       (sha256 obj))))
