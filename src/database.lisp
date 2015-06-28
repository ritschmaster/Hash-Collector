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

(in-package #:hash-collector)

(defvar *sqlite-db-path* (getf
                          (getf
                           (envy:config :hash-collector)
                           :database-connection-spec)
                          :database-name)
  "This variable points to the sqlite database. The path is the directory from where the lisp interpreter has been started.")
(defvar *sqlite-persist-query-password-hashes*
  *sqlite-persist-query-password-hashes-default*
  "The insert query template. It can be later filled with values (to avoid SQL injection).")
(defvar *sqlite-get-single-query-password-hashes*
  *sqlite-get-single-query-password-hashes-default*
  "The select query template. It can be later filled with values (to avoid SQL injection).")
(defvar *sqlite-db* nil
  "Holds the sqlite instance.")

(defun connect-db (filename)
  "Connects to a sqlite database with the path FILENAME and stores it in the variable *sqlite-db*."
  (setf *sqlite-db*
        (sqlite:connect *sqlite-db-path*)))

(defun disconnect-db ()
  "Disconnects the sqlite database stored in *sqlite-db*."
  (sqlite:disconnect *sqlite-db*))

(defgeneric is-persisted (obj)
  (:documentation
   "Method to ask if a specific object is available in the database"))
(defmethod is-persisted ((obj password-hashes))
    (sqlite:execute-single
     *sqlite-db*
     *sqlite-get-single-query-password-hashes*
     (plaintext obj)))

(defgeneric persist (obj)
  (:documentation "Method to persist an object in the database."))
(defmethod persist ((obj password-hashes))
  (when (not (is-persisted obj))
      (sqlite:execute-non-query
       *sqlite-db*
       *sqlite-persist-query-password-hashes*
       (plaintext obj)
       (md5 obj)
       (sha256 obj))))
