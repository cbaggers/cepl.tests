(in-package :cepl.tests)

;;------------------------------------------------------------

(5am:def-suite cepl.types)
(5am:in-suite cepl.types)

;;------------------------------------------------------------

(defstruct-g test-struct-0
  (foo :uint)
  (bar (:uint 10)))

(def-test structs-0 (:suite cepl.types)
  (ensure-cepl
    (let ((data (loop :for i :below 3 :collect
                   (list i (loop :for x :below 10 :collect x)))))
      (with-free* ((arr (make-gpu-array data
                                        :dimensions 3
                                        :element-type 'test-struct-0)))
        (is (equal data (pull-g arr)))))))
;;------------------------------------------------------------
