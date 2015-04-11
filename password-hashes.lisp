(in-package #:hash-collector)

(defclass password-hashes ()
  ((plaintext
    :initform (error "Must supply plaintext!")
    :initarg :plaintext
    :reader plaintext)
   (md5
    :initform nil)
   (sha256
    :initform nil)))
(defgeneric (setf md5) (value obj))
(defmethod (setf md5) ((value vector) (obj password-hashes))
  (with-slots (md5) obj
    (setf md5 (vector-to-string value))))
(defmethod (setf md5) ((value string) (obj password-hashes))
  (with-slots (md5) obj
    (setf md5 string)))
(defgeneric md5 (obj))
(defmethod md5 ((obj password-hashes))
  (slot-value obj 'md5))

(defgeneric (setf sha256) (value obj))
(defmethod (setf sha256) ((value vector) (obj password-hashes))
  (with-slots (sha256) obj
    (setf sha256 (vector-to-string value))))
(defmethod (setf sha256) ((value string) (obj password-hashes))
  (with-slots (sha256) obj
    (setf sha256 string)))
(defgeneric sha256 (obj))
(defmethod sha256 ((obj password-hashes))
  (slot-value obj 'sha256))

(defun create-password-hashes (str)
  (let ((pw-hashes (make-instance 'password-hashes
                                  :plaintext str)))
    (setf (md5 pw-hashes)
         (ironclad:digest-sequence
          :md5
          (ironclad:ascii-string-to-byte-array
           str)))
    (setf (sha256 pw-hashes)
          (ironclad:digest-sequence
            :sha256
            (ironclad:ascii-string-to-byte-array
             str)))
    pw-hashes))
