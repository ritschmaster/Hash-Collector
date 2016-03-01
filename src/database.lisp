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
(defpackage hash-collector.database
  (:use :cl
        :hash-collector.password-hashes)
  (:import-from :sqlite
                :connect
                :disconnect
                :execute-single
                :execute-non-query)
  (:import-from :envy
                :config)
  (:export :connect-db
           :disconnect-db
           :is-persisted
           :persist
           :*sqlite-db-path*))
(in-package :hash-collector.database)

;; The following variables are parameters. Parameters are variables
;; whose value can't be changed. Those are are used for ultimately
;; fixed values. Using parameters to set variables (defvar) is a good
;; practise to be able to change dynamic global variables in runtime.
(defparameter *sqlite-persist-query-password-hashes-default*
  "insert into hashes (plaintext, md5, sha256) values (?, ?, ?)")
(defparameter *sqlite-get-single-query-password-hashes-default*
  "select hash_id from hashes where plaintext = ?")

(defvar *sqlite-db-path* (getf
                          (getf
                           (config :hash-collector.config)
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
        (connect *sqlite-db-path*)))

(defun disconnect-db ()
  "Disconnects the sqlite database stored in *sqlite-db*."
  (disconnect *sqlite-db*))

(defgeneric is-persisted (obj)
  (:documentation
   "Method to ask if a specific object is available in the database"))
(defmethod is-persisted ((obj <password-hashes>))
  (execute-single
   *sqlite-db*
   *sqlite-get-single-query-password-hashes*
   (plaintext obj)))

(defgeneric persist (obj)
  (:documentation "Method to persist an object in the database."))
(defmethod persist ((obj <password-hashes>))
  (when (not (is-persisted obj))
    (execute-non-query
     *sqlite-db*
     *sqlite-persist-query-password-hashes*
     (plaintext obj)
     (md5 obj)
     (sha256 obj))))
