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

;; The following variables are parameters. Parameters are variables
;; whose value can't be changed. Those are are used for ultimately
;; fixed values. Using parameters to set variables (defvar) is a good
;; practise to be able to change dynamic global variables in runtime.

;; config parameters:
(defparameter *standard-env-var* "APP_ENV")

;; permutation parameters:
(defparameter *letters-default*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
(defparameter *letters-with-numbers*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
(defparameter *letters-german-with-numbers-with-punctuations*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789äöüÄÖÜ.-+?!")

;; database parameters:
(defparameter *sqlite-db-name-default* "hash.db")
(defparameter *sqlite-persist-query-password-hashes-default*
  "insert into hashes (plaintext, md5, sha256) values (?, ?, ?)")
(defparameter *sqlite-get-single-query-password-hashes-default*
  "select hash_id from hashes where plaintext = ?")

;;-----------------------------------------------------------------------
;; setting up envy starts here:
;;-----------------------------------------------------------------------
(defvar *env-var* *standard-env-var*)
(setf (envy:config-env-var) *env-var*)

(defvar *application-root* (asdf:component-pathname
                            (asdf:find-system :hash-collector)))
(defvar *development-database-name* (merge-pathnames
                                     *sqlite-db-name-default*
                                     *application-root*))

(envy:defconfig :common
    `(:application-root ,*application-root*))

(envy:defconfig |development|
    (list :debug t
          :database-type :sqlite3
          :database-connection-spec
          (list :database-name *development-database-name*)))

(envy:defconfig |production|
    (list :debug nil
          :database-type :mysql
          :database-connection-spec
          (list :database-name "test"
                :usename "whoami"
                :password "1234")))


