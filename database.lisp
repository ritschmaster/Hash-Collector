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
