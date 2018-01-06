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

(def-test gpu-array-3 (:suite cepl.gpu-arrays.buffer-backed)
  (let ((data '(1 2 3 4 5 6)))
    (ensure-cepl
      (with-free* ((arr-0 (make-gpu-array data))
                   (arr-1 (make-gpu-array data)))
        ;; just try scoped binding a bunch of times and ensure
        ;; the target is truly bound
        (loop :for i :below 10 :do
           (cepl:with-gpu-array-as-pointer (ptr-0
                                            arr-0
                                            :access-type :write-only
                                            :target :array-buffer)
             ptr-0 arr-0
             (cepl:with-gpu-array-as-pointer (ptr-1
                                              arr-1
                                              :access-type :write-only
                                              :target :element-array-buffer)
               ptr-1 arr-1
               (is (> (gl:get* :array-buffer-binding) 0))
               (is (> (gl:get* :element-array-buffer-binding) 0))))
           (setf (gpu-buffer-bound (cepl-context) :array-buffer)
                 nil)
           (setf (gpu-buffer-bound (cepl-context) :element-array-buffer)
                 nil))))))
