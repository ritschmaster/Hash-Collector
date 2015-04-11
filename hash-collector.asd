;;;; hash-collector.asd

(asdf:defsystem #:hash-collector
  :description "hash-collector is a simple applications which permuts a string with a
specific length and persists all its different hashes."
  :author "Richard Bäck <richard.baeck@openmailbox.org>"
  :license "GPLv3"
  :depends-on (#:sqlite
               #:ironclad)
  :serial t
  :components ((:file "package")
               (:file "util")
               (:file "parameters")
               (:file "password-hashes")
               (:file "database")
               (:file "hash-collector")))

