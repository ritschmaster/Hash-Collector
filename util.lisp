(in-package #:hash-collector)

(defun vector-to-string (vec)
  (declare (vector vec))
  (let ((str ""))
    (declare (string str))
    (loop for num across vec do
         (setf str (concatenate 'string
                                str
                                (write-to-string num))))
    str))
