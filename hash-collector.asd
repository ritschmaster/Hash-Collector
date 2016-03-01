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

(asdf:defsystem #:hash-collector
  :description "HASH-COLLECTOR is a simple applications which permuts a string with a
specific length and persists all its different hashes."
  :author "Richard Bäck <richard.baeck@openmailbox.org>"
  :license "GPLv3"

  ;; library dependencies:
  :depends-on (:sqlite
               :ironclad
               :envy)

  ;; read in the :components one by one (otherwise for each component
  ;; a ":depends-on" has to be used)
  :serial t

  ;; the components of this application
  :components ((:module "src" ; declares the folder "src" as module
                        :components ; files in the folder "src" to include
                        ((:file "util")
                         (:file "config")
                         (:file "password-hashes")
                         (:file "database")
                         (:file "hash-collector")))
               (:file "hash-collector") ; a file in the toplevel directory
               ))

