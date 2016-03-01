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
(defpackage hash-collector.config
  (:use :cl
        :hash-collector.util)
  (:import-from :envy
                :config-env-var
                :defconfig))
(in-package :hash-collector.config)

;; config parameters:
(defparameter *standard-env-var* "APP_ENV")
(defparameter *sqlite-db-name-default* "hash.db")

;;-----------------------------------------------------------------------
;; setting up envy starts here:
;;-----------------------------------------------------------------------
(defvar *env-var* *standard-env-var*)
(setf (config-env-var) *env-var*)

(defvar *application-root* (asdf:component-pathname
                            (asdf:find-system :hash-collector)))
(defvar *development-database-name* (merge-pathnames
                                     *sqlite-db-name-default*
                                     *application-root*))

(defconfig :common
    `(:application-root ,*application-root*))

(defconfig |development|
    (list :debug t
          :database-type :sqlite3
          :database-connection-spec
          (list :database-name *development-database-name*)))

(defconfig |production|
    (list :debug nil
          :database-type :mysql
          :database-connection-spec
          (list :database-name "test"
                :usename "whoami"
                :password "1234"))) 
