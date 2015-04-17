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

(defparameter *letters-default*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
(defparameter *letters-with-numbers*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
(defparameter *letters-german-with-numbers-with-punctuations*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789äöüÄÖÜ.-+?!")

(defparameter *base-path-default* "http://localhost:4567/")

(defparameter *sqlite-db-path-default* "hash.db")
(defparameter *sqlite-persist-query-password-hashes-default*
  "insert into hashes (plaintext, md5, sha256) values (?, ?, ?)")
(defparameter *sqlite-get-single-query-password-hashes-default*
  "select hash_id from hashes where plaintext = ?")
