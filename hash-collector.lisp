(in-package #:hash-collector)

(defvar *letters* *letters-default*)
(defvar *base-path* *base-path-default*)

(defun get-letters ()
  *letters*)

(defun permut (len cur-str callback)
  "Permuts a passwort with given letters and a length declared by LEN. CUR-STR should always be \"\"."
  (declare (fixnum len)
           (string cur-str))
  (if (= len (length cur-str))
      (funcall callback cur-str)
      (progn
        (let ((letter-vector (get-letters))
              (ret-val nil))
          (loop for l across letter-vector do
               (setf ret-val (permut len
                               (concatenate 'string
                                            cur-str
                                            (string l))
                               callback))
               (when (not (null ret-val))
                 (return-from permut ret-val)))))))

(defun create-and-persist-hashes (str)
  (let ((hash (create-password-hashes str)))
    (persist hash))
  nil)

;; (defun call-url (url)
;;   (if (= (nth-value 1 (drakma:http-request (concatenate 'string
;;                                                  *base-path*
;;                                                  url)))
;;            200)
;;       url
;;       nil))

(defun collect (len)
  (connect-db *sqlite-db-path*)
  (permut len "" #'create-and-persist-hashes)
  (disconnect-db))
