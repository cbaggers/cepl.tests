(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(5am:def-suite cepl.gpu-arrays.buffer-backed)
(5am:in-suite cepl.gpu-arrays.buffer-backed)

;;------------------------------------------------------------

(def-test gpu-array-0 (:suite cepl.gpu-arrays.buffer-backed)
  (let ((data '(1 2 3 4 5)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (is (equal data (pull-g arr)))))))

(def-test gpu-array-1 (:suite cepl.gpu-arrays.buffer-backed)
  (let ((data '(1 2 3 4 5 6)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (with-gpu-array-as-c-array (carr arr)
          (is (equal data (pull-g carr))))))))

(def-test gpu-array-2 (:suite cepl.gpu-arrays.buffer-backed)
  (let ((data '(1 2 3 4 5 6)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (with-gpu-array-range-as-c-array (carr arr 1 3)
          (is (equal (subseq data 1 4) (pull-g carr))))))))

;;------------------------------------------------------------
