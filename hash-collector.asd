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

(asdf:defsystem #:hash-collector
  :description "hash-collector is a simple applications which permuts a string with a
specific length and persists all its different hashes."
  :author "Richard Bäck <richard.baeck@openmailbox.org>"
  :license "GPLv3"
  :depends-on (#:sqlite
               #:ironclad)
  :serial t
  :components ((:file "package")
               (:module "src"
                        :components
                        ((:file "util")
                         (:file "parameters")
                         (:file "password-hashes")
                         (:file "database")
                         (:file "hash-collector")))))

