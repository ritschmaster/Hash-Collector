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
